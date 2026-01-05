import styles from './SectionTitle.module.css';
import { useScrollAnimation } from '../../hooks/useScrollAnimation';

export function SectionTitle({
  title,
  subtitle,
  centered = true,
  gradient = false,
  className = '',
}) {
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.2 });

  const containerClasses = [
    styles.container,
    centered ? styles.centered : '',
    isVisible ? styles.visible : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  const titleClasses = [
    styles.title,
    gradient ? styles.gradient : '',
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <div ref={ref} className={containerClasses}>
      <h2 className={titleClasses}>{title}</h2>
      {subtitle && <p className={styles.subtitle}>{subtitle}</p>}
    </div>
  );
}

export default SectionTitle;
