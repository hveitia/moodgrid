import styles from './Button.module.css';

export function Button({
  children,
  variant = 'primary',
  size = 'medium',
  href,
  onClick,
  icon,
  iconPosition = 'left',
  fullWidth = false,
  disabled = false,
  className = '',
  ...props
}) {
  const buttonClasses = [
    styles.button,
    styles[variant],
    styles[size],
    fullWidth ? styles.fullWidth : '',
    disabled ? styles.disabled : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  const content = (
    <>
      {icon && iconPosition === 'left' && <span className={styles.icon}>{icon}</span>}
      <span className={styles.text}>{children}</span>
      {icon && iconPosition === 'right' && <span className={styles.icon}>{icon}</span>}
    </>
  );

  if (href) {
    return (
      <a
        href={href}
        className={buttonClasses}
        target="_blank"
        rel="noopener noreferrer"
        {...props}
      >
        {content}
      </a>
    );
  }

  return (
    <button
      className={buttonClasses}
      onClick={onClick}
      disabled={disabled}
      {...props}
    >
      {content}
    </button>
  );
}

export default Button;
