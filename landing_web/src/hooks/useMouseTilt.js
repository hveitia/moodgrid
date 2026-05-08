import { useEffect, useRef } from 'react';

const prefersReducedMotion = () =>
  typeof window !== 'undefined' &&
  window.matchMedia &&
  window.matchMedia('(prefers-reduced-motion: reduce)').matches;

const isFinePointer = () =>
  typeof window !== 'undefined' &&
  window.matchMedia &&
  window.matchMedia('(hover: hover) and (pointer: fine)').matches;

export function useMouseTilt({
  maxTilt = 8,
  perspective = 1000,
  smoothing = 0.12,
  scaleOnHover = 1.02,
} = {}) {
  const ref = useRef(null);

  useEffect(() => {
    const node = ref.current;
    if (!node || prefersReducedMotion() || !isFinePointer()) return;

    let rect = node.getBoundingClientRect();
    let target = { x: 0, y: 0, scale: 1 };
    let current = { x: 0, y: 0, scale: 1 };
    let frame;
    let active = false;

    const updateRect = () => {
      rect = node.getBoundingClientRect();
    };

    const tick = () => {
      current.x += (target.x - current.x) * smoothing;
      current.y += (target.y - current.y) * smoothing;
      current.scale += (target.scale - current.scale) * smoothing;

      const settled =
        Math.abs(target.x - current.x) < 0.01 &&
        Math.abs(target.y - current.y) < 0.01 &&
        Math.abs(target.scale - current.scale) < 0.001;

      const atRest =
        !active &&
        settled &&
        Math.abs(current.x) < 0.05 &&
        Math.abs(current.y) < 0.05 &&
        Math.abs(current.scale - 1) < 0.005;

      if (atRest) {
        node.style.transform = '';
      } else {
        node.style.transform = `perspective(${perspective}px) rotateX(${current.y.toFixed(2)}deg) rotateY(${current.x.toFixed(2)}deg) scale(${current.scale.toFixed(3)})`;
      }

      if (active || !settled) {
        frame = requestAnimationFrame(tick);
      } else {
        frame = null;
      }
    };

    const start = () => {
      active = true;
      target.scale = scaleOnHover;
      if (!frame) frame = requestAnimationFrame(tick);
    };

    const move = (e) => {
      const x = (e.clientX - rect.left) / rect.width - 0.5;
      const y = (e.clientY - rect.top) / rect.height - 0.5;
      target.x = x * maxTilt * 2;
      target.y = -y * maxTilt * 2;
    };

    const end = () => {
      active = false;
      target.x = 0;
      target.y = 0;
      target.scale = 1;
      if (!frame) frame = requestAnimationFrame(tick);
    };

    node.addEventListener('mouseenter', start);
    node.addEventListener('mousemove', move);
    node.addEventListener('mouseleave', end);
    window.addEventListener('resize', updateRect);
    window.addEventListener('scroll', updateRect, { passive: true });

    return () => {
      node.removeEventListener('mouseenter', start);
      node.removeEventListener('mousemove', move);
      node.removeEventListener('mouseleave', end);
      window.removeEventListener('resize', updateRect);
      window.removeEventListener('scroll', updateRect);
      if (frame) cancelAnimationFrame(frame);
      node.style.transform = '';
    };
  }, [maxTilt, perspective, smoothing, scaleOnHover]);

  return ref;
}

export default useMouseTilt;
