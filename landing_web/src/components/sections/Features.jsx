import { Container, SectionTitle } from '../common';
import { useMultipleScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './Features.module.css';

const FEATURE_VISUALS = [
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="3" width="7" height="7" rx="1.5" />
        <rect x="14" y="3" width="7" height="7" rx="1.5" />
        <rect x="14" y="14" width="7" height="7" rx="1.5" />
        <rect x="3" y="14" width="7" height="7" rx="1.5" />
      </svg>
    ),
    color: '#88B486',
    span: 2,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="3" width="18" height="18" rx="2" />
        <path d="M3 9h18" />
        <path d="M9 21V9" />
      </svg>
    ),
    color: '#90AFCF',
    span: 1,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
        <line x1="8" y1="6" x2="16" y2="6" />
        <line x1="8" y1="10" x2="16" y2="10" />
        <line x1="8" y1="14" x2="12" y2="14" />
      </svg>
    ),
    color: '#EED694',
    span: 1,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <path d="M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z" />
      </svg>
    ),
    color: '#E3A676',
    span: 1,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 3v18h18" />
        <path d="M18 17V9" />
        <path d="M13 17V5" />
        <path d="M8 17v-3" />
      </svg>
    ),
    color: '#D68078',
    span: 1,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="11" width="18" height="11" rx="2" />
        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
      </svg>
    ),
    color: '#88B486',
    span: 1,
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
        <polyline points="17 8 12 3 7 8" />
        <line x1="12" y1="3" x2="12" y2="15" />
      </svg>
    ),
    color: '#90AFCF',
    span: 1,
  },
];

export function Features() {
  const t = useT();
  const items = t.features.items;
  const [setRef, visibleItems] = useMultipleScrollAnimation(items.length, {
    threshold: 0.1,
    staggerDelay: 60,
  });

  return (
    <section className={styles.section} id="features">
      <Container>
        <SectionTitle
          eyebrow={t.features.eyebrow}
          title={t.features.title}
          subtitle={t.features.subtitle}
          gradient
        />

        <ul className={styles.grid}>
          {items.map((feature, index) => {
            const visual = FEATURE_VISUALS[index] || FEATURE_VISUALS[0];
            return (
              <li
                key={index}
                ref={setRef(index)}
                className={`${styles.card} ${visibleItems[index] ? styles.visible : ''} ${styles[`span${visual.span}`]}`}
                style={{ '--feature-color': visual.color }}
              >
                <span className={styles.iconWrap}>
                  <span className={styles.iconHalo} />
                  <span className={styles.icon}>{visual.icon}</span>
                </span>
                <h3 className={styles.cardTitle}>{feature.title}</h3>
                <p className={styles.cardDescription}>{feature.description}</p>
              </li>
            );
          })}
        </ul>
      </Container>
    </section>
  );
}

export default Features;
