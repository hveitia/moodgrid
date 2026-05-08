import { Container, SectionTitle } from '../common';
import { useMultipleScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './HowItWorks.module.css';

const STEP_COLORS = ['#88B486', '#90AFCF', '#E3A676'];
const MOOD_PALETTE = ['#88B486', '#90AFCF', '#EED694', '#E3A676', '#D68078'];

function StepGridPreview({ activeIndex }) {
  return (
    <div className={styles.previewGrid} aria-hidden="true">
      {Array.from({ length: 25 }).map((_, i) => {
        const colorIdx = (i * 7 + activeIndex * 3) % MOOD_PALETTE.length;
        return (
          <span
            key={i}
            className={styles.previewCell}
            style={{
              background: MOOD_PALETTE[colorIdx],
              transitionDelay: `${i * 18}ms`,
            }}
          />
        );
      })}
    </div>
  );
}

function StepMoodPicker() {
  return (
    <div className={styles.previewPicker} aria-hidden="true">
      {MOOD_PALETTE.map((c, i) => (
        <span
          key={c}
          className={styles.previewPickerDot}
          style={{
            background: c,
            transform: i === 0 ? 'scale(1.2)' : 'scale(1)',
            boxShadow: i === 0 ? `0 0 0 4px rgba(136, 180, 134, 0.3)` : 'none',
          }}
        />
      ))}
    </div>
  );
}

function StepStats() {
  const data = [70, 45, 60, 30, 18];
  return (
    <div className={styles.previewStats} aria-hidden="true">
      {data.map((v, i) => (
        <span
          key={i}
          className={styles.previewBar}
          style={{
            background: MOOD_PALETTE[i],
            transform: `scaleY(${v / 100})`,
            transitionDelay: `${i * 60}ms`,
          }}
        />
      ))}
    </div>
  );
}

const PREVIEWS = [<StepGridPreview key="0" activeIndex={0} />, <StepMoodPicker key="1" />, <StepStats key="2" />];

export function HowItWorks() {
  const t = useT();
  const [setRef, visibleItems] = useMultipleScrollAnimation(t.howItWorks.steps.length, {
    threshold: 0.2,
    staggerDelay: 80,
  });

  return (
    <section className={styles.section} id="how-it-works">
      <Container>
        <SectionTitle
          eyebrow={t.howItWorks.eyebrow}
          title={t.howItWorks.title}
          subtitle={t.howItWorks.subtitle}
          gradient
        />

        <ol className={styles.steps}>
          {t.howItWorks.steps.map((step, index) => (
            <li
              key={index}
              ref={setRef(index)}
              className={`${styles.step} ${visibleItems[index] ? styles.visible : ''}`}
              style={{ '--step-color': STEP_COLORS[index] }}
            >
              <div className={styles.stepPreview}>
                {PREVIEWS[index]}
              </div>
              <div className={styles.stepContent}>
                <span className={styles.stepNumber}>{String(index + 1).padStart(2, '0')}</span>
                <h3 className={styles.stepTitle}>{step.title}</h3>
                <p className={styles.stepDescription}>{step.description}</p>
              </div>
            </li>
          ))}
        </ol>
      </Container>
    </section>
  );
}

export default HowItWorks;
