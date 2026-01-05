import { useState } from 'react';
import { Container, SectionTitle } from '../common';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';
import styles from './Screenshots.module.css';

const SCREENSHOTS = [
  {
    id: 1,
    title: 'Grid View',
    image: 'https://placehold.co/390x844/88B486/FFFFFF?text=Grid+View',
    color: '#88B486',
  },
  {
    id: 2,
    title: 'Year in Pixels',
    image: 'https://placehold.co/390x844/90AFCF/FFFFFF?text=Year+Pixels',
    color: '#90AFCF',
  },
  {
    id: 3,
    title: 'Journal',
    image: 'https://placehold.co/390x844/EED694/2C2C2C?text=Journal',
    color: '#EED694',
  },
  {
    id: 4,
    title: 'Word Cloud',
    image: 'https://placehold.co/390x844/E3A676/FFFFFF?text=Word+Cloud',
    color: '#E3A676',
  },
  {
    id: 5,
    title: 'Stats',
    image: 'https://placehold.co/390x844/D68078/FFFFFF?text=Stats',
    color: '#D68078',
  },
];

export function Screenshots() {
  const [activeIndex, setActiveIndex] = useState(2);
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.2 });

  const handlePrev = () => {
    setActiveIndex((prev) => (prev === 0 ? SCREENSHOTS.length - 1 : prev - 1));
  };

  const handleNext = () => {
    setActiveIndex((prev) => (prev === SCREENSHOTS.length - 1 ? 0 : prev + 1));
  };

  return (
    <section className={styles.screenshots} id="screenshots">
      <Container>
        <SectionTitle
          title="Capturas de Pantalla"
          subtitle="Descubre la interfaz intuitiva y visualmente atractiva de Feelmap"
          gradient
        />

        <div
          ref={ref}
          className={`${styles.carousel} ${isVisible ? styles.visible : ''}`}
        >
          <button
            className={`${styles.navButton} ${styles.navPrev}`}
            onClick={handlePrev}
            aria-label="Anterior"
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M15 18l-6-6 6-6"/>
            </svg>
          </button>

          <div className={styles.screenshotsContainer}>
            {SCREENSHOTS.map((screenshot, index) => {
              const offset = index - activeIndex;
              const isActive = index === activeIndex;

              return (
                <div
                  key={screenshot.id}
                  className={`${styles.screenshot} ${isActive ? styles.active : ''}`}
                  style={{
                    '--offset': offset,
                    '--color': screenshot.color,
                  }}
                  onClick={() => setActiveIndex(index)}
                >
                  <div className={styles.phoneFrame}>
                    <div className={styles.phoneScreen}>
                      <img
                        src={screenshot.image}
                        alt={screenshot.title}
                        className={styles.screenshotImage}
                      />
                    </div>
                  </div>
                  {isActive && (
                    <span className={styles.screenshotTitle}>{screenshot.title}</span>
                  )}
                </div>
              );
            })}
          </div>

          <button
            className={`${styles.navButton} ${styles.navNext}`}
            onClick={handleNext}
            aria-label="Siguiente"
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M9 18l6-6-6-6"/>
            </svg>
          </button>
        </div>

        <div className={styles.indicators}>
          {SCREENSHOTS.map((_, index) => (
            <button
              key={index}
              className={`${styles.indicator} ${index === activeIndex ? styles.indicatorActive : ''}`}
              onClick={() => setActiveIndex(index)}
              aria-label={`Ir a captura ${index + 1}`}
              style={{ '--color': SCREENSHOTS[index].color }}
            />
          ))}
        </div>
      </Container>
    </section>
  );
}

export default Screenshots;
