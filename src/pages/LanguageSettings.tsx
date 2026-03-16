import { useEffect } from "react";
import { Languages } from "lucide-react";
import { useBreadcrumbs } from "../context/BreadcrumbContext";
import { useLanguage, type Language } from "../context/LanguageContext";

const LANGUAGE_OPTIONS: Array<{ value: Language; label: string; nativeLabel: string }> = [
  { value: "en", label: "English", nativeLabel: "English" },
  { value: "zh", label: "Chinese", nativeLabel: "中文" },
];

export function LanguageSettings() {
  const { setBreadcrumbs } = useBreadcrumbs();
  const { language, setLanguage, t } = useLanguage();

  useEffect(() => {
    setBreadcrumbs([
      { label: t.instanceSettings },
      { label: t.language },
    ]);
  }, [setBreadcrumbs, t]);

  return (
    <div className="max-w-2xl space-y-6">
      <div className="space-y-2">
        <div className="flex items-center gap-2">
          <Languages className="h-5 w-5 text-muted-foreground" />
          <h1 className="text-lg font-semibold">{t.language}</h1>
        </div>
        <p className="text-sm text-muted-foreground">
          {t.languageHint}
        </p>
      </div>

      <div className="grid gap-3 sm:grid-cols-2">
        {LANGUAGE_OPTIONS.map((opt) => (
          <button
            key={opt.value}
            type="button"
            className={[
              "rounded-lg border px-4 py-4 text-left transition-colors",
              language === opt.value
                ? "border-foreground bg-accent/40"
                : "border-border hover:bg-accent/30",
            ].join(" ")}
            onClick={() => setLanguage(opt.value)}
          >
            <div className="text-sm font-medium">{opt.nativeLabel}</div>
            <div className="text-xs text-muted-foreground mt-1">{opt.label}</div>
          </button>
        ))}
      </div>
    </div>
  );
}
