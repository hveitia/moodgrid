import styles from './Container.module.css';

export function Container({
  children,
  size = 'default',
  className = '',
  as: Component = 'div',
  ...props
}) {
  const containerClasses = [
    styles.container,
    styles[size],
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <Component className={containerClasses} {...props}>
      {children}
    </Component>
  );
}

export default Container;
