import { Container } from '../common';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './Hero.module.css';

const APP_STORE = 'https://apps.apple.com/app/feelmap/id6756886570';
const PLAY_STORE = 'https://play.google.com/store/apps/details?id=com.hveitia.moodgrid.moodgrid';

const MOOD_PALETTE = [
  '#88B486',
  '#90AFCF',
  '#EED694',
  '#E3A676',
  '#D68078',
];

function AppleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22" aria-hidden="true">
      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
    </svg>
  );
}

function PlayIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" width="22" height="22" aria-hidden="true">
      <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z" />
    </svg>
  );
}

function ShieldIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" width="14" height="14" aria-hidden="true">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
    </svg>
  );
}

function CloudOffIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" width="14" height="14" aria-hidden="true">
      <path d="M2 2l20 20"/>
      <path d="M5.78 5.78A4 4 0 0 0 9 13h9.26"/>
      <path d="M21 13a4 4 0 0 0-3-3.87"/>
      <path d="M11 4a4 4 0 0 1 5 3"/>
    </svg>
  );
}


export function Hero() {
  const t = useT();
  const [headlineRef, headlineVisible] = useScrollAnimation({ threshold: 0 });

  return (
    <section className={styles.hero} id="hero">
      <div className={styles.background} aria-hidden="true">
        <div className={styles.glow} />
        <div className={styles.glowB} />
      </div>

      <Container>
        <div className={styles.layout}>
          <div
            ref={headlineRef}
            className={`${styles.text} ${headlineVisible ? styles.visible : ''}`}
          >
            <span className={styles.eyebrow}>
              <span className={styles.eyebrowDot} />
              {t.hero.eyebrow}
            </span>

            <h1 className={styles.title}>
              <span className={styles.titleLine}>{t.hero.titleLine1}</span>{' '}
              <span className={`${styles.titleLine} ${styles.titleAccent}`}>{t.hero.titleLine2}</span>
            </h1>

            <p className={styles.description}>{t.hero.description}</p>

            <div className={styles.buttons}>
              <a
                href={APP_STORE}
                target="_blank"
                rel="noopener noreferrer"
                className={`${styles.cta} ${styles.ctaPrimary}`}
              >
                <AppleIcon />
                <span className={styles.ctaText}>
                  <small>{t.cta.downloadOn}</small>
                  <strong>{t.cta.appStore}</strong>
                </span>
              </a>
              <a
                href={PLAY_STORE}
                target="_blank"
                rel="noopener noreferrer"
                className={`${styles.cta} ${styles.ctaSecondary}`}
              >
                <PlayIcon />
                <span className={styles.ctaText}>
                  <small>{t.cta.downloadOn}</small>
                  <strong>{t.cta.playStore}</strong>
                </span>
              </a>
            </div>

            <ul className={styles.trust}>
              <li className={styles.trustItem}>
                <span className={styles.trustIcon}><ShieldIcon /></span>
                {t.hero.trust.private}
              </li>
              <li className={styles.trustItem}>
                <span className={styles.trustIcon}><CloudOffIcon /></span>
                {t.hero.trust.offline}
              </li>
            </ul>

            <div className={styles.moodLegend} aria-hidden="true">
              {MOOD_PALETTE.map((c) => (
                <span key={c} className={styles.moodDot} style={{ background: c }} />
              ))}
              <span className={styles.moodLegendText}>{t.hero.legend}</span>
            </div>
          </div>

          <div className={styles.mockupWrapper}>
            <div className={styles.mockupTilt}>
              <div className={styles.phoneFrame}>
                <div className={styles.phoneNotch} />
                <div className={styles.phoneScreen}>
                  <img
                    src="/IMG_8421.PNG"
                    alt={t.hero.mockupAlt}
                    className={styles.mockupImage}
                    fetchpriority="high"
                    width="390"
                    height="844"
                  />
                </div>
              </div>
              <div className={styles.mockupGlow} />
            </div>
          </div>
        </div>
      </Container>

      <a href="#year-reveal" className={styles.scrollIndicator} aria-label={t.hero.scrollHint}>
        <span className={styles.scrollText}>{t.hero.scrollHint}</span>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M12 5v14M5 12l7 7 7-7"/>
        </svg>
      </a>
    </section>
  );
}

export default Hero;
