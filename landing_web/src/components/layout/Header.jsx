import { useState, useEffect } from 'react';
import { Container } from '../common';
import { useT, LanguageSwitch } from '../../i18n';
import styles from './Header.module.css';

const APP_STORE = 'https://apps.apple.com/app/feelmap/id6756886570';
const PLAY_STORE = 'https://play.google.com/store/apps/details?id=com.hveitia.moodgrid.moodgrid';

function LogoMark() {
  return (
    <img
      src="/favicon.png"
      alt=""
      width="32"
      height="32"
      loading="eager"
      decoding="async"
      aria-hidden="true"
    />
  );
}

function AppleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true">
      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
    </svg>
  );
}

function PlayIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true">
      <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z" />
    </svg>
  );
}

export function Header() {
  const t = useT();
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const navLinks = [
    { label: t.nav.howItWorks, href: '#how-it-works' },
    { label: t.nav.features, href: '#features' },
    { label: t.nav.screenshots, href: '#screenshots' },
    { label: t.nav.privacy, href: '#privacy' },
    { label: t.nav.faq, href: '#faq' },
  ];

  useEffect(() => {
    const onScroll = () => setIsScrolled(window.scrollY > 12);
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    document.body.style.overflow = isMenuOpen ? 'hidden' : '';
    return () => {
      document.body.style.overflow = '';
    };
  }, [isMenuOpen]);

  const close = () => setIsMenuOpen(false);

  return (
    <header className={`${styles.header} ${isScrolled ? styles.scrolled : ''}`}>
      <Container>
        <nav className={styles.nav} aria-label={t.nav.ariaLabel}>
          <a href="#" className={styles.logo} onClick={close}>
            <span className={styles.logoIcon}><LogoMark /></span>
            <span className={styles.logoText}>EmotionsMap</span>
          </a>

          <ul className={styles.navLinks}>
            {navLinks.map((link) => (
              <li key={link.href}>
                <a href={link.href} className={styles.navLink}>{link.label}</a>
              </li>
            ))}
          </ul>

          <div className={styles.actions}>
            <LanguageSwitch className={styles.langSwitch} />
            <a
              href={APP_STORE}
              className={`${styles.storeButton} ${styles.appleButton}`}
              aria-label={t.nav.appStoreAria}
              target="_blank"
              rel="noopener noreferrer"
            >
              <AppleIcon />
              <span>{t.cta.appStore}</span>
            </a>
            <a
              href={PLAY_STORE}
              className={`${styles.storeButton} ${styles.playButton}`}
              aria-label={t.nav.playStoreAria}
              target="_blank"
              rel="noopener noreferrer"
            >
              <PlayIcon />
              <span>{t.cta.playStore}</span>
            </a>
          </div>

          <button
            className={`${styles.mobileMenuButton} ${isMenuOpen ? styles.active : ''}`}
            onClick={() => setIsMenuOpen((v) => !v)}
            aria-label={isMenuOpen ? t.nav.closeMenu : t.nav.openMenu}
            aria-expanded={isMenuOpen}
          >
            <span /><span /><span />
          </button>
        </nav>
      </Container>

      <div className={`${styles.mobilePanel} ${isMenuOpen ? styles.mobilePanelOpen : ''}`} aria-hidden={!isMenuOpen}>
        <ul className={styles.mobileLinks}>
          {navLinks.map((link) => (
            <li key={link.href}>
              <a href={link.href} className={styles.mobileLink} onClick={close}>{link.label}</a>
            </li>
          ))}
        </ul>
        <div className={styles.mobileActions}>
          <LanguageSwitch />
          <a href={APP_STORE} className={`${styles.storeButton} ${styles.appleButton}`} target="_blank" rel="noopener noreferrer">
            <AppleIcon />
            <span>{t.cta.appStore}</span>
          </a>
          <a href={PLAY_STORE} className={`${styles.storeButton} ${styles.playButton}`} target="_blank" rel="noopener noreferrer">
            <PlayIcon />
            <span>{t.cta.playStore}</span>
          </a>
        </div>
      </div>
    </header>
  );
}

export default Header;
