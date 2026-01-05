import { Container, Button } from '../common';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';
import styles from './Hero.module.css';

const PARTICLE_COLORS = ['#88B486', '#90AFCF', '#EED694', '#E3A676', '#D68078'];

const PARTICLES = [...Array(20)].map((_, i) => ({
  id: i,
  delay: `${Math.random() * 5}s`,
  x: `${Math.random() * 100}%`,
  y: `${Math.random() * 100}%`,
  size: `${Math.random() * 10 + 5}px`,
  color: PARTICLE_COLORS[Math.floor(Math.random() * PARTICLE_COLORS.length)],
}));

export function Hero() {
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.1 });

  return (
    <section className={styles.hero} id="hero">
      <div className={styles.background}>
        <div className={styles.gradientOrb1}></div>
        <div className={styles.gradientOrb2}></div>
        <div className={styles.gradientOrb3}></div>
        <div className={styles.particles}>
          {PARTICLES.map((particle) => (
            <span
              key={particle.id}
              className={styles.particle}
              style={{
                '--delay': particle.delay,
                '--x': particle.x,
                '--y': particle.y,
                '--size': particle.size,
                '--color': particle.color,
              }}
            ></span>
          ))}
        </div>
      </div>

      <Container>
        <div ref={ref} className={`${styles.content} ${isVisible ? styles.visible : ''}`}>
          <div className={styles.text}>
            <h1 className={styles.title}>
              <span className={styles.titleGradient}>Feelmap</span>
            </h1>
            <p className={styles.tagline}>
              Visualiza tus emociones, cuida tu bienestar
            </p>
            <p className={styles.description}>
              Registra tu estado de ánimo diario con una interfaz visual inspirada en GitHub.
              Descubre patrones emocionales, escribe en tu diario y cuida tu salud mental.
            </p>

            <div className={styles.buttons}>
              <Button
                href="#"
                variant="primary"
                size="large"
                icon={
                  <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                  </svg>
                }
              >
                App Store
              </Button>
              <Button
                href="#"
                variant="secondary"
                size="large"
                icon={
                  <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                    <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
                  </svg>
                }
              >
                Google Play
              </Button>
            </div>

            <div className={styles.stats}>
              <div className={styles.stat}>
                <span className={styles.statNumber}>100%</span>
                <span className={styles.statLabel}>Privado</span>
              </div>
              <div className={styles.statDivider}></div>
              <div className={styles.stat}>
                <span className={styles.statNumber}>5</span>
                <span className={styles.statLabel}>Estados de ánimo</span>
              </div>
              <div className={styles.statDivider}></div>
              <div className={styles.stat}>
                <span className={styles.statNumber}>365</span>
                <span className={styles.statLabel}>Días de seguimiento</span>
              </div>
            </div>
          </div>

          <div className={styles.mockup}>
            <div className={styles.phoneFrame}>
              <div className={styles.phoneScreen}>
                <img
                  src="https://placehold.co/390x844/FAFAFA/88B486?text=Feelmap+App"
                  alt="Feelmap App Preview"
                  className={styles.mockupImage}
                />
              </div>
            </div>
            <div className={styles.mockupGlow}></div>
          </div>
        </div>
      </Container>

      <div className={styles.scrollIndicator}>
        <span className={styles.scrollText}>Descubre más</span>
        <div className={styles.scrollArrow}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M12 5v14M5 12l7 7 7-7"/>
          </svg>
        </div>
      </div>
    </section>
  );
}

export default Hero;
