import styles from './Card.module.css';

export function Card({
  children,
  variant = 'default',
  hover = true,
  padding = 'medium',
  className = '',
  ...props
}) {
  const cardClasses = [
    styles.card,
    styles[variant],
    styles[`padding-${padding}`],
    hover ? styles.hoverable : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <div className={cardClasses} {...props}>
      {children}
    </div>
  );
}

export default Card;
