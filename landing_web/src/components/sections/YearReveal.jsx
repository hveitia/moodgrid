import { useEffect, useMemo, useRef, useState } from 'react';
import { Container, SectionTitle } from '../common';
import { useLanguage, format } from '../../i18n';
import styles from './YearReveal.module.css';

const COLS = 52;
const ROWS = 7;
const TOTAL = COLS * ROWS;

const PALETTE = [
  '#88B486',
  '#90AFCF',
  '#EED694',
  '#E3A676',
  '#D68078',
];

const MONTH_KEYS = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
const MONTH_LABELS = {
  en: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  es: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
};

function generatePattern() {
  const cells = new Array(TOTAL);
  let n = 314159;
  for (let i = 0; i < TOTAL; i += 1) {
    n = (n * 1103515245 + 12345) % 2147483647;
    const r = n / 2147483647;
    if (r < 0.08) {
      cells[i] = -1;
    } else {
      const week = Math.floor(i / ROWS);
      const seasonShift = Math.sin(week / 8) * 0.3;
      const adjusted = Math.min(1, Math.max(0, r + seasonShift));
      cells[i] = Math.floor(adjusted * PALETTE.length) % PALETTE.length;
    }
  }
  return cells;
}

const prefersReduced = () =>
  typeof window !== 'undefined' &&
  window.matchMedia &&
  window.matchMedia('(prefers-reduced-motion: reduce)').matches;

export function YearReveal() {
  const { t, lang } = useLanguage();
  const sectionRef = useRef(null);
  const [progress, setProgress] = useState(() => (prefersReduced() ? 1 : 0));
  const cells = useMemo(() => generatePattern(), []);

  useEffect(() => {
    const node = sectionRef.current;
    if (!node || prefersReduced()) return;

    let ticking = false;

    const update = () => {
      const rect = node.getBoundingClientRect();
      const vh = window.innerHeight;
      const start = vh * 0.85;
      const end = vh * 0.15;
      const visible = start - rect.top;
      const range = start - end;
      const ratio = Math.min(1, Math.max(0, visible / range));
      setProgress(ratio);
      ticking = false;
    };

    const onScroll = () => {
      if (!ticking) {
        requestAnimationFrame(update);
        ticking = true;
      }
    };

    update();
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', update);
    return () => {
      window.removeEventListener('scroll', onScroll);
      window.removeEventListener('resize', update);
    };
  }, []);

  const filled = Math.floor(progress * TOTAL);
  const percent = Math.round(progress * 100);
  const months = MONTH_LABELS[lang] || MONTH_LABELS.en;
  const legendItems = [
    { c: '#88B486', l: t.yearReveal.legend.excellent },
    { c: '#90AFCF', l: t.yearReveal.legend.good },
    { c: '#EED694', l: t.yearReveal.legend.neutral },
    { c: '#E3A676', l: t.yearReveal.legend.difficult },
    { c: '#D68078', l: t.yearReveal.legend.bad },
  ];

  return (
    <section ref={sectionRef} className={styles.section} id="year-reveal">
      <Container>
        <SectionTitle
          eyebrow={t.yearReveal.eyebrow}
          title={t.yearReveal.title}
          subtitle={t.yearReveal.subtitle}
          gradient
        />

        <div className={styles.frame}>
          <div className={styles.frameHeader}>
            <span className={styles.frameTitle}>{t.yearReveal.frameTitle}</span>
            <span className={styles.frameYear}>2026</span>
            <span className={styles.frameProgress}>{format(t.yearReveal.progress, { n: percent })}</span>
          </div>

          <div className={styles.gridWrapper}>
            <div className={styles.monthLabels} aria-hidden="true">
              {months.map((m, i) => (
                <span key={MONTH_KEYS[i]} className={styles.monthLabel}>{m}</span>
              ))}
            </div>

            <div
              className={styles.grid}
              style={{
                gridTemplateColumns: `repeat(${COLS}, 1fr)`,
                gridTemplateRows: `repeat(${ROWS}, 1fr)`,
              }}
              role="img"
              aria-label={format(t.yearReveal.ariaProgress, { n: percent })}
            >
              {cells.map((value, idx) => {
                const isFilled = idx < filled;
                const color = value === -1 ? 'rgba(31, 45, 31, 0.05)' : PALETTE[value];
                return (
                  <span
                    key={idx}
                    className={styles.cell}
                    style={{
                      background: isFilled ? color : 'rgba(31, 45, 31, 0.05)',
                      transitionDelay: isFilled ? `${(idx % ROWS) * 8}ms` : '0ms',
                      transform: isFilled ? 'scale(1)' : 'scale(0.9)',
                      opacity: isFilled ? (value === -1 ? 0.5 : 1) : 0.6,
                    }}
                  />
                );
              })}
            </div>
          </div>

          <div className={styles.legend}>
            {legendItems.map(({ c, l }) => (
              <span key={l} className={styles.legendItem}>
                <span className={styles.legendDot} style={{ background: c }} />
                {l}
              </span>
            ))}
          </div>
        </div>

        <p className={styles.caption}>{t.yearReveal.caption}</p>
      </Container>
    </section>
  );
}

export default YearReveal;
