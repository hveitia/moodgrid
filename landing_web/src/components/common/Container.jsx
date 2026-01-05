import styles from './Container.module.css';

export function Container({
  children,
  size = 'default',
  className = '',
  as = 'div',
  ...props
}) {
  const containerClasses = [
    styles.container,
    styles[size],
    className,
  ]
    .filter(Boolean)
    .join(' ');

  const Element = as;
  return (
    <Element className={containerClasses} {...props}>
      {children}
    </Element>
  );
}

export default Container;
