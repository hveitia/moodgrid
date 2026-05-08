import { useEffect, useRef, useState } from 'react';

const ioSupported = () => typeof IntersectionObserver !== 'undefined';

export function useScrollAnimation(options = {}) {
  const {
    threshold = 0.15,
    rootMargin = '0px 0px -10% 0px',
    triggerOnce = true,
  } = options;

  const elementRef = useRef(null);
  const [isVisible, setIsVisible] = useState(() => !ioSupported());

  useEffect(() => {
    const element = elementRef.current;
    if (!element || !ioSupported()) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          if (triggerOnce) observer.unobserve(element);
        } else if (!triggerOnce) {
          setIsVisible(false);
        }
      },
      { threshold, rootMargin }
    );

    observer.observe(element);
    return () => observer.disconnect();
  }, [threshold, rootMargin, triggerOnce]);

  return [elementRef, isVisible];
}

export function useMultipleScrollAnimation(count, options = {}) {
  const refs = useRef([]);
  const [visibleItems, setVisibleItems] = useState(() =>
    new Array(count).fill(!ioSupported())
  );

  const {
    threshold = 0.15,
    rootMargin = '0px 0px -10% 0px',
    triggerOnce = true,
    staggerDelay = 60,
  } = options;

  useEffect(() => {
    if (!ioSupported()) return;

    const currentRefs = refs.current;
    const observers = currentRefs.map((element, index) => {
      if (!element) return null;

      const observer = new IntersectionObserver(
        ([entry]) => {
          if (entry.isIntersecting) {
            const delay = index * staggerDelay;
            window.setTimeout(() => {
              setVisibleItems((prev) => {
                if (prev[index]) return prev;
                const next = [...prev];
                next[index] = true;
                return next;
              });
            }, delay);

            if (triggerOnce) observer.unobserve(element);
          } else if (!triggerOnce) {
            setVisibleItems((prev) => {
              const next = [...prev];
              next[index] = false;
              return next;
            });
          }
        },
        { threshold, rootMargin }
      );

      observer.observe(element);
      return observer;
    });

    return () => {
      observers.forEach((observer) => observer && observer.disconnect());
    };
  }, [count, threshold, rootMargin, triggerOnce, staggerDelay]);

  const setRef = (index) => (element) => {
    refs.current[index] = element;
  };

  return [setRef, visibleItems];
}

export default useScrollAnimation;
