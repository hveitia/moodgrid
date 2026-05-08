import { Container } from '../common';
import { useT, format } from '../../i18n';
import styles from './Footer.module.css';

const PRIVACY_URL = '/privacy';
const TERMS_URL = '/terms';
const SUPPORT_URL = '/support';
const APP_STORE = 'https://apps.apple.com/app/feelmap/id6756886570';
const PLAY_STORE = 'https://play.google.com/store/apps/details?id=com.hveitia.moodgrid.moodgrid';

function LogoMark() {
  return (
    <img
      src="/favicon.png"
      alt=""
      width="32"
      height="32"
      loading="lazy"
      decoding="async"
      aria-hidden="true"
    />
  );
}

export function Footer() {
  const t = useT();
  const year = new Date().getFullYear();

  const groups = [
    {
      title: t.footer.product,
      links: [
        { label: t.footer.links.howItWorks, href: '#how-it-works' },
        { label: t.footer.links.features, href: '#features' },
        { label: t.footer.links.screenshots, href: '#screenshots' },
        { label: t.footer.links.faq, href: '#faq' },
      ],
    },
    {
      title: t.footer.download,
      links: [
        { label: t.footer.links.appStore, href: APP_STORE, external: true },
        { label: t.footer.links.playStore, href: PLAY_STORE, external: true },
      ],
    },
    {
      title: t.footer.legal,
      links: [
        { label: t.footer.links.privacy, href: PRIVACY_URL },
        { label: t.footer.links.terms, href: TERMS_URL },
        { label: t.footer.links.support, href: SUPPORT_URL },
      ],
    },
  ];

  return (
    <footer className={styles.footer}>
      <Container>
        <div className={styles.content}>
          <div className={styles.brand}>
            <a href="#" className={styles.logo}>
              <span className={styles.logoIcon}><LogoMark /></span>
              <span className={styles.logoText}>EmotionsMap</span>
            </a>
            <p className={styles.tagline}>{t.footer.tagline}</p>
            <div className={styles.moodStrip} aria-hidden="true">
              <span style={{ background: '#88B486' }} />
              <span style={{ background: '#90AFCF' }} />
              <span style={{ background: '#EED694' }} />
              <span style={{ background: '#E3A676' }} />
              <span style={{ background: '#D68078' }} />
            </div>
          </div>

          <div className={styles.links}>
            {groups.map((group) => (
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
          <p className={styles.copyright}>{format(t.footer.copyright, { year })}</p>
          <p className={styles.madeWith}>{t.footer.madeWith}</p>
        </div>
      </Container>
    </footer>
  );
}

export default Footer;
