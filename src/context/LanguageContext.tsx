import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import { en, type TranslationKeys } from "../i18n/en";
import { zh } from "../i18n/zh";

export type Language = "en" | "zh";
export type Translations = TranslationKeys;

const LANG_STORAGE_KEY = "paperclip.language";

const translations: Record<Language, Translations> = { en, zh };

interface LanguageContextValue {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: Translations;
}

const LanguageContext = createContext<LanguageContextValue | undefined>(undefined);

function resolveLanguage(): Language {
  if (typeof window === "undefined") return "en";
  try {
    const stored = localStorage.getItem(LANG_STORAGE_KEY);
    if (stored === "en" || stored === "zh") return stored;
  } catch {}
  return "en";
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLangState] = useState<Language>(() => resolveLanguage());

  const setLanguage = useCallback((lang: Language) => {
    setLangState(lang);
    try {
      localStorage.setItem(LANG_STORAGE_KEY, lang);
    } catch {}
  }, []);

  const t = translations[language];

  const value = useMemo(
    () => ({ language, setLanguage, t }),
    [language, setLanguage, t],
  );

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error("useLanguage must be used within LanguageProvider");
  }
  return context;
}
