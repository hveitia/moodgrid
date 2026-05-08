import { Container } from '../common';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './Privacy.module.css';

const POINT_ICONS = [
  (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" key="1">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      <path d="M9 12l2 2 4-4" />
    </svg>
  ),
  (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" key="2">
      <circle cx="12" cy="12" r="9" />
      <path d="M3.6 9h16.8" />
      <path d="M3.6 15h16.8" />
      <path d="M11.5 3a16 16 0 0 0 0 18" />
      <path d="M12.5 3a16 16 0 0 1 0 18" />
      <line x1="3" y1="3" x2="21" y2="21" />
    </svg>
  ),
  (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" key="3">
      <circle cx="12" cy="12" r="3" />
      <path d="M12 2v2" />
      <path d="M12 20v2" />
      <path d="M4.93 4.93l1.41 1.41" />
      <path d="M17.66 17.66l1.41 1.41" />
      <path d="M2 12h2" />
      <path d="M20 12h2" />
      <path d="M4.93 19.07l1.41-1.41" />
      <path d="M17.66 6.34l1.41-1.41" />
      <line x1="3" y1="3" x2="21" y2="21" />
    </svg>
  ),
  (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" key="4">
      <rect x="3" y="11" width="18" height="11" rx="2" />
      <path d="M7 11V7a5 5 0 0 1 10 0v4" />
      <circle cx="12" cy="16" r="1" fill="currentColor" />
    </svg>
  ),
];

export function Privacy() {
  const t = useT();
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.2 });

  return (
    <section className={styles.section} id="privacy">
      <Container>
        <div ref={ref} className={`${styles.layout} ${isVisible ? styles.visible : ''}`}>
          <div className={styles.intro}>
            <span className={styles.eyebrow}>
              <span className={styles.eyebrowDot} />
              {t.privacy.eyebrow}
            </span>
            <h2 className={styles.title}>
              {t.privacy.titleBefore} <em>{t.privacy.titleEm}</em> {t.privacy.titleAfter}
            </h2>
            <p className={styles.subtitle}>{t.privacy.subtitle}</p>
            <a href="#cta" className={styles.cta}>
              {t.privacy.cta}
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="5" y1="12" x2="19" y2="12" />
                <polyline points="12 5 19 12 12 19" />
              </svg>
            </a>
          </div>

          <ul className={styles.points}>
            {t.privacy.points.map((p, i) => (
              <li
                key={i}
                className={styles.point}
                style={{ '--delay': `${i * 80}ms` }}
              >
                <span className={styles.pointIcon}>{POINT_ICONS[i]}</span>
                <h3 className={styles.pointTitle}>{p.title}</h3>
                <p className={styles.pointDesc}>{p.description}</p>
              </li>
            ))}
          </ul>
        </div>
      </Container>
    </section>
  );
}

export default Privacy;
