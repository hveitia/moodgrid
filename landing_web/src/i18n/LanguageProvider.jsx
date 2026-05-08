import { useEffect, useMemo, useState } from 'react';
import { LanguageContext } from './context';
import { translations, SUPPORTED_LANGUAGES, DEFAULT_LANGUAGE } from './translations';

const STORAGE_KEY = 'feelmap.lang';

function readStoredLang() {
  if (typeof window === 'undefined') return DEFAULT_LANGUAGE;
  try {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (stored && SUPPORTED_LANGUAGES.includes(stored)) return stored;
  } catch {
    // ignore
  }
  return DEFAULT_LANGUAGE;
}

export function LanguageProvider({ children }) {
  const [lang, setLangState] = useState(readStoredLang);

  useEffect(() => {
    if (typeof document !== 'undefined') {
      document.documentElement.lang = lang;
    }
    try {
      window.localStorage.setItem(STORAGE_KEY, lang);
    } catch {
      // ignore
    }
  }, [lang]);

  const value = useMemo(() => {
    const t = translations[lang] ?? translations[DEFAULT_LANGUAGE];
    const setLang = (next) => {
      if (SUPPORTED_LANGUAGES.includes(next)) setLangState(next);
    };
    return { lang, setLang, t };
  }, [lang]);

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>;
}

export default LanguageProvider;
