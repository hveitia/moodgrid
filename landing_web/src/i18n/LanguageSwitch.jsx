import { useLanguage } from './context';
import styles from './LanguageSwitch.module.css';

const LANGS = [
  { code: 'en', label: 'EN' },
  { code: 'es', label: 'ES' },
];

export function LanguageSwitch({ className = '' }) {
  const { lang, setLang, t } = useLanguage();

  return (
    <div
      className={`${styles.switch} ${className}`}
      role="group"
      aria-label={t.languageSwitch.ariaLabel}
    >
      <span
        className={styles.indicator}
        style={{ transform: `translateX(${LANGS.findIndex((l) => l.code === lang) * 100}%)` }}
        aria-hidden="true"
      />
      {LANGS.map((l) => (
        <button
          key={l.code}
          type="button"
          onClick={() => setLang(l.code)}
          className={`${styles.option} ${lang === l.code ? styles.active : ''}`}
          aria-pressed={lang === l.code}
          aria-label={t.languageSwitch[l.code]}
        >
          {l.label}
        </button>
      ))}
    </div>
  );
}

export default LanguageSwitch;
