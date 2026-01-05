import { Container } from '../common';
import styles from './Footer.module.css';

const FOOTER_LINKS = [
  {
    title: 'Producto',
    links: [
      { label: 'Características', href: '#features' },
      { label: 'Capturas', href: '#screenshots' },
      { label: 'FAQ', href: '#faq' },
    ],
  },
  {
    title: 'Legal',
    links: [
      { label: 'Privacidad', href: 'https://hveitia.github.io/apps_stores_docs/apps/moodgrid/privacy-policy.html', external: true },
      { label: 'Términos', href: 'https://hveitia.github.io/apps_stores_docs/apps/moodgrid/terms-and-conditions.html', external: true },
    ],
  },
];

const SOCIAL_LINKS = [];

export function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className={styles.footer}>
      <Container>
        <div className={styles.content}>
          <div className={styles.brand}>
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
            <p className={styles.tagline}>
              Visualiza tus emociones, cuida tu bienestar
            </p>

            <div className={styles.social}>
              {SOCIAL_LINKS.map((social) => (
                <a
                  key={social.label}
                  href={social.href}
                  className={styles.socialLink}
                  aria-label={social.label}
                >
                  {social.icon}
                </a>
              ))}
            </div>
          </div>

          <div className={styles.links}>
            {FOOTER_LINKS.map((group) => (
              <div key={group.title} className={styles.linkGroup}>
                <h4 className={styles.linkGroupTitle}>{group.title}</h4>
                <ul className={styles.linkList}>
                  {group.links.map((link) => (
                    <li key={link.label}>
                      <a
                        href={link.href}
                        className={styles.link}
                        {...(link.external && { target: '_blank', rel: 'noopener noreferrer' })}
                      >
                        {link.label}
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>

        <div className={styles.bottom}>
          <p className={styles.copyright}>
            © {currentYear} Feelmap. Todos los derechos reservados.
          </p>
          <p className={styles.madeWith}>
            Hecho con <span className={styles.heart}>♥</span> para tu bienestar
          </p>
        </div>
      </Container>
    </footer>
  );
}

export default Footer;
