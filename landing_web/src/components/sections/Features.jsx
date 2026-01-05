import { Container, SectionTitle, Card } from '../common';
import { useMultipleScrollAnimation } from '../../hooks/useScrollAnimation';
import styles from './Features.module.css';

const FEATURES = [
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="3" width="7" height="7"/>
        <rect x="14" y="3" width="7" height="7"/>
        <rect x="14" y="14" width="7" height="7"/>
        <rect x="3" y="14" width="7" height="7"/>
      </svg>
    ),
    title: 'Grid Visual tipo GitHub',
    description: 'Visualiza tu año emocional como un mapa de calor. Cada celda representa un día coloreado según tu estado de ánimo.',
    color: 'var(--color-mood-excellent)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="3" width="18" height="18" rx="2"/>
        <path d="M3 9h18"/>
        <path d="M9 21V9"/>
      </svg>
    ),
    title: 'Mi Año en Píxeles',
    description: 'Vista compacta de 365 días del año con todos tus registros emocionales en una sola pantalla.',
    color: 'var(--color-mood-good)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
        <line x1="8" y1="6" x2="16" y2="6"/>
        <line x1="8" y1="10" x2="16" y2="10"/>
        <line x1="8" y1="14" x2="12" y2="14"/>
      </svg>
    ),
    title: 'Diario con Búsqueda',
    description: 'Agrega notas a cada día. Busca en tus reflexiones pasadas y encuentra patrones en tu escritura.',
    color: 'var(--color-mood-neutral)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z"/>
      </svg>
    ),
    title: 'Nube de Palabras',
    description: 'Descubre las palabras más frecuentes en tus reflexiones. Los colores indican el estado emocional asociado.',
    color: 'var(--color-mood-difficult)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 3v18h18"/>
        <path d="M18 17V9"/>
        <path d="M13 17V5"/>
        <path d="M8 17v-3"/>
      </svg>
    ),
    title: 'Estadísticas y Reflexiones',
    description: 'Analiza tus hábitos de escritura, rachas de registro y descubre tu mes más productivo.',
    color: 'var(--color-mood-bad)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
      </svg>
    ),
    title: 'Seguridad con PIN',
    description: 'Protege tu diario emocional con un PIN. Tus datos personales, siempre seguros.',
    color: 'var(--color-mood-excellent)',
  },
  {
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
        <polyline points="17 8 12 3 7 8"/>
        <line x1="12" y1="3" x2="12" y2="15"/>
      </svg>
    ),
    title: 'Export/Import de Datos',
    description: 'Exporta tus datos como JSON o imágenes. Importa backups para nunca perder tu historial.',
    color: 'var(--color-mood-good)',
  },
];

export function Features() {
  const [setRef, visibleItems] = useMultipleScrollAnimation(FEATURES.length, {
    threshold: 0.1,
    staggerDelay: 100,
  });

  return (
    <section className={styles.features} id="features">
      <Container>
        <SectionTitle
          title="Características"
          subtitle="Todo lo que necesitas para cuidar tu bienestar emocional en una sola app"
          gradient
        />

        <div className={styles.grid}>
          {FEATURES.map((feature, index) => (
            <Card
              key={index}
              hover
              padding="large"
              className={`${styles.featureCard} ${visibleItems[index] ? styles.visible : ''}`}
            >
              <div
                ref={setRef(index)}
                className={styles.featureContent}
              >
                <div
                  className={styles.iconWrapper}
                  style={{ '--icon-color': feature.color }}
                >
                  {feature.icon}
                </div>
                <h3 className={styles.featureTitle}>{feature.title}</h3>
                <p className={styles.featureDescription}>{feature.description}</p>
              </div>
            </Card>
          ))}
        </div>
      </Container>
    </section>
  );
}

export default Features;
