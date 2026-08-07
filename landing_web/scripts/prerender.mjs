import { spawn, execFileSync } from 'node:child_process';
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const PORT = 4986;
const DIST_INDEX = fileURLToPath(new URL('../dist/index.html', import.meta.url));

if (!existsSync(CHROME)) {
  console.warn('[prerender] Chrome not found, skipping prerender step');
  process.exit(0);
}

const preview = spawn('npx', ['vite', 'preview', '--port', String(PORT), '--strictPort'], {
  cwd: fileURLToPath(new URL('..', import.meta.url)),
  stdio: 'ignore',
  detached: true,
});

async function waitForServer() {
  for (let i = 0; i < 50; i++) {
    try {
      const res = await fetch(`http://localhost:${PORT}/`);
      if (res.ok) return;
    } catch {
      // server not up yet
    }
    await new Promise((r) => setTimeout(r, 200));
  }
  throw new Error('vite preview did not start');
}

let dom;
try {
  await waitForServer();
  dom = execFileSync(
    CHROME,
    [
      '--headless',
      '--disable-gpu',
      '--hide-scrollbars',
      '--virtual-time-budget=8000',
      '--dump-dom',
      `http://localhost:${PORT}/`,
    ],
    { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 },
  );
} finally {
  try {
    process.kill(-preview.pid);
  } catch {
    preview.kill();
  }
}

const match = dom.match(/<div id="root">([\s\S]*)<\/div>\s*<\/body>/);
if (!match || match[1].trim().length < 500) {
  console.error('[prerender] could not extract rendered content from #root');
  process.exit(1);
}

const html = readFileSync(DIST_INDEX, 'utf8');
if (!html.includes('<div id="root"></div>')) {
  console.error('[prerender] empty #root placeholder not found in dist/index.html');
  process.exit(1);
}
writeFileSync(DIST_INDEX, html.replace('<div id="root"></div>', `<div id="root">${match[1]}</div>`));
console.log(`[prerender] injected ${(match[1].length / 1024).toFixed(1)} kB of static HTML into dist/index.html`);
