import { useState, useEffect } from 'react';
import { Container } from '../common';
import styles from './Header.module.css';

const NAV_LINKS = [
  { label: 'Características', href: '#features' },
  { label: 'Capturas', href: '#screenshots' },
  { label: 'FAQ', href: '#faq' },
];

export function Header() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const toggleMobileMenu = () => {
    setIsMobileMenuOpen(!isMobileMenuOpen);
  };

  const closeMobileMenu = () => {
    setIsMobileMenuOpen(false);
  };

  return (
    <header className={`${styles.header} ${isScrolled ? styles.scrolled : ''}`}>
      <Container>
        <nav className={styles.nav}>
          <a href="#" className={styles.logo}>
            <span className={styles.logoIcon}>
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="3" y="3" width="7" height="7" rx="1.5" fill="#88B486"/>
                <rect x="14" y="3" width="7" height="7" rx="1.5" fill="#90AFCF"/>
                <rect x="3" y="14" width="7" height="7" rx="1.5" fill="#EED694"/>
                <rect x="14" y="14" width="7" height="7" rx="1.5" fill="#E3A676"/>
              </svg>
            </span>
            <span className={styles.logoText}>Feelmap</span>
          </a>

          <ul className={`${styles.navLinks} ${isMobileMenuOpen ? styles.mobileOpen : ''}`}>
            {NAV_LINKS.map((link) => (
              <li key={link.href}>
                <a
                  href={link.href}
                  className={styles.navLink}
                  onClick={closeMobileMenu}
                >
                  {link.label}
                </a>
              </li>
            ))}
          </ul>

          <div className={styles.actions}>
            <a
              href="#"
              className={styles.downloadButton}
              aria-label="Descargar en App Store"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
              </svg>
              <span>App Store</span>
            </a>
            <a
              href="#"
              className={styles.downloadButton}
              aria-label="Descargar en Google Play"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
              </svg>
              <span>Google Play</span>
            </a>
          </div>

          <button
            className={`${styles.mobileMenuButton} ${isMobileMenuOpen ? styles.active : ''}`}
            onClick={toggleMobileMenu}
            aria-label="Abrir menú"
            aria-expanded={isMobileMenuOpen}
          >
            <span></span>
            <span></span>
            <span></span>
          </button>
        </nav>
      </Container>
    </header>
  );
}

export default Header;
