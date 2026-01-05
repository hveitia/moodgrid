import { useEffect, useRef, useState } from 'react';

export function useScrollAnimation(options = {}) {
  const {
    threshold = 0.1,
    rootMargin = '0px',
    triggerOnce = true,
  } = options;

  const elementRef = useRef(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const element = elementRef.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          if (triggerOnce) {
            observer.unobserve(element);
          }
        } else if (!triggerOnce) {
          setIsVisible(false);
        }
      },
      {
        threshold,
        rootMargin,
      }
    );

    observer.observe(element);

    return () => {
      observer.unobserve(element);
    };
  }, [threshold, rootMargin, triggerOnce]);

  return [elementRef, isVisible];
}

export function useMultipleScrollAnimation(count, options = {}) {
  const refs = useRef([]);
  const [visibleItems, setVisibleItems] = useState(new Array(count).fill(false));

  const {
    threshold = 0.1,
    rootMargin = '0px',
    triggerOnce = true,
    staggerDelay = 100,
  } = options;

  useEffect(() => {
    const observers = refs.current.map((element, index) => {
      if (!element) return null;

      const observer = new IntersectionObserver(
        ([entry]) => {
          if (entry.isIntersecting) {
            setTimeout(() => {
              setVisibleItems((prev) => {
                const newState = [...prev];
                newState[index] = true;
                return newState;
              });
            }, index * staggerDelay);

            if (triggerOnce) {
              observer.unobserve(element);
            }
          } else if (!triggerOnce) {
            setVisibleItems((prev) => {
              const newState = [...prev];
              newState[index] = false;
              return newState;
            });
          }
        },
        {
          threshold,
          rootMargin,
        }
      );

      observer.observe(element);
      return observer;
    });

    return () => {
      observers.forEach((observer, index) => {
        if (observer && refs.current[index]) {
          observer.unobserve(refs.current[index]);
        }
      });
    };
  }, [count, threshold, rootMargin, triggerOnce, staggerDelay]);

  const setRef = (index) => (element) => {
    refs.current[index] = element;
  };

  return [setRef, visibleItems];
}

export default useScrollAnimation;
