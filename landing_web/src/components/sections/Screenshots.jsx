import { useEffect, useState } from 'react';
import { Container, SectionTitle } from '../common';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './Screenshots.module.css';

const SCREENSHOT_VISUALS = [
  { image: '/IMG_8421.PNG', color: '#88B486' },
  { image: '/IMG_8420.PNG', color: '#90AFCF' },
  { image: '/IMG_8419.PNG', color: '#EED694' },
  { image: '/IMG_8422.PNG', color: '#E3A676' },
  { image: '/IMG_8423.PNG', color: '#D68078' },
];

export function Screenshots() {
  const t = useT();
  const items = t.screenshots.items.map((it, i) => ({ ...it, ...SCREENSHOT_VISUALS[i] }));
  const [activeIndex, setActiveIndex] = useState(0);
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.2 });

  useEffect(() => {
    const onKey = (e) => {
      if (e.key === 'ArrowRight') setActiveIndex((p) => (p + 1) % items.length);
      if (e.key === 'ArrowLeft') setActiveIndex((p) => (p - 1 + items.length) % items.length);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [items.length]);

  const handlePrev = () => setActiveIndex((p) => (p - 1 + items.length) % items.length);
  const handleNext = () => setActiveIndex((p) => (p + 1) % items.length);

  const active = items[activeIndex];

  return (
    <section className={styles.section} id="screenshots">
      <div
        className={styles.bgTint}
        style={{ background: `radial-gradient(60% 60% at 50% 50%, ${active.color}33, transparent 70%)` }}
        aria-hidden="true"
      />

      <Container>
        <SectionTitle
          eyebrow={t.screenshots.eyebrow}
          title={t.screenshots.title}
          subtitle={t.screenshots.subtitle}
          gradient
        />

        <div ref={ref} className={`${styles.carousel} ${isVisible ? styles.visible : ''}`}>
          <button
            className={`${styles.navButton} ${styles.navPrev}`}
            onClick={handlePrev}
            aria-label={t.screenshots.ariaPrev}
            type="button"
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M15 18l-6-6 6-6" />
            </svg>
          </button>

          <div className={styles.stage}>
            {items.map((s, index) => {
              const offset = index - activeIndex;
              const abs = Math.abs(offset);
              const isActive = index === activeIndex;
              return (
                <button
                  key={index}
                  className={`${styles.slide} ${isActive ? styles.slideActive : ''}`}
                  type="button"
                  onClick={() => setActiveIndex(index)}
                  style={{
                    '--offset': offset,
                    '--abs': abs,
                    zIndex: items.length - abs,
                    pointerEvents: abs > 2 ? 'none' : 'auto',
                  }}
                  aria-label={`${t.screenshots.ariaSee} ${s.title}`}
                  aria-current={isActive}
                  tabIndex={isActive ? 0 : -1}
                >
                  <div className={styles.phoneFrame}>
                    <div className={styles.phoneNotch} />
                    <div className={styles.phoneScreen}>
                      <img
                        src={s.image}
                        alt={`${s.title}: ${s.caption}`}
                        className={styles.image}
                        loading={abs <= 1 ? 'eager' : 'lazy'}
                        decoding="async"
                      />
                    </div>
                  </div>
                </button>
              );
            })}
          </div>

          <button
            className={`${styles.navButton} ${styles.navNext}`}
            onClick={handleNext}
            aria-label={t.screenshots.ariaNext}
            type="button"
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M9 18l6-6-6-6" />
            </svg>
          </button>
        </div>

        <div className={styles.captionRow}>
          <div className={styles.captionText} key={activeIndex}>
            <h3 className={styles.captionTitle}>{active.title}</h3>
            <p className={styles.captionSubtitle}>{active.caption}</p>
          </div>
        </div>

        <div className={styles.indicators} role="tablist" aria-label={t.screenshots.ariaList}>
          {items.map((s, index) => (
            <button
              key={index}
              role="tab"
              aria-selected={index === activeIndex}
              aria-label={`${t.screenshots.ariaGoTo} ${index + 1}`}
              className={`${styles.indicator} ${index === activeIndex ? styles.indicatorActive : ''}`}
              onClick={() => setActiveIndex(index)}
              style={{ '--color': s.color }}
              type="button"
            />
          ))}
        </div>
      </Container>
    </section>
  );
}

export default Screenshots;
