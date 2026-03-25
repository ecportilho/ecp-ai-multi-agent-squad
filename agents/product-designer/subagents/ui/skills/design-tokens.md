---
name: design-tokens
description: >
  Extrair e organizar tokens de design do design_spec.md em CSS variables, Tailwind config e tokens mobile. Use ao iniciar a Fase 03 para gerar os tokens que o Front End usará como fonte de verdade visual.
---

# Skill: design-tokens

## Objetivo
Gerar tokens de design prontos para uso em cada plataforma, baseados na identidade visual do produto (conforme design_spec.md).
Referência: `{REPO_DESTINO}/design_spec.md`, `design_spec.md`, `design_spec.md`.

---

## WEB — Tailwind CSS (globals.css + tailwind.config.ts)

### globals.css (CSS variables → shadcn/ui theme)
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    /* shadcn/ui semantic tokens — dark theme */
    --background: 214 25% 7%;           /* #0b0f14 */
    --foreground: 214 60% 95%;          /* #eaf2ff */
    --card: 214 30% 11%;               /* #131c28 */
    --card-foreground: 214 60% 95%;
    --popover: 214 30% 11%;
    --popover-foreground: 214 60% 95%;
    --primary: 83 100% 58%;            /* #b7ff2a lime */
    --primary-foreground: 214 25% 7%;  /* dark text on lime */
    --secondary: 214 28% 9%;           /* #0f1620 */
    --secondary-foreground: 214 25% 65%; /* #a9b7cc */
    --muted: 214 28% 9%;
    --muted-foreground: 214 20% 55%;   /* #7b8aa3 */
    --accent: 83 100% 58%;
    --accent-foreground: 214 25% 7%;
    --destructive: 0 100% 65%;         /* #ff4d4d */
    --destructive-foreground: 214 60% 95%;
    --border: 214 28% 22%;             /* #27364a */
    --input: 214 28% 22%;
    --ring: 83 100% 58%;               /* lime focus ring */
    --radius: 0.875rem;                /* 14px */

    /* o produto (conforme design_spec.md) custom tokens */
    --color-bg-primary: #0b0f14;
    --color-bg-secondary: #0f1620;
    --color-bg-elevated: #131c28;
    --color-bg-overlay: rgba(11,15,20,0.80);
    --color-border-subtle: #1c2836;
    --color-border-default: #27364a;
    --color-border-strong: #36516d;
    --color-brand-lime-500: #b7ff2a;
    --color-brand-lime-600: #9eea12;
    --color-brand-lime-700: #7ed100;
    --color-brand-lime-glow: rgba(183,255,42,0.20);
    --color-success: #3dff8b;
    --color-warning: #ffcc00;
    --color-danger: #ff4d4d;
    --color-info: #4da3ff;
    --gradient-brand: linear-gradient(90deg, #b7ff2a 0%, #4da3ff 100%);
    --ease-standard: cubic-bezier(0.2,0.8,0.2,1);
    --duration-fast: 140ms;
    --duration-base: 200ms;
    --duration-slow: 260ms;
    --sidebar-width: 280px;
    --topbar-height: 64px;
  }
}
```

### tailwind.config.ts (extend)
```typescript
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        "ecp-bg": "#0b0f14",
        "ecp-surface": "#131c28",
        "ecp-surface-2": "#0f1620",
        "ecp-border": "#27364a",
        "ecp-border-subtle": "#1c2836",
        "ecp-text": "#eaf2ff",
        "ecp-text-secondary": "#a9b7cc",
        "ecp-text-muted": "#7b8aa3",
        "ecp-lime": "#b7ff2a",
        "ecp-lime-hover": "#9eea12",
        "ecp-lime-pressed": "#7ed100",
        "ecp-success": "#3dff8b",
        "ecp-warning": "#ffcc00",
        "ecp-danger": "#ff4d4d",
        "ecp-info": "#4da3ff",
      },
      borderRadius: {
        xs: "6px",
        sm: "10px",
        md: "14px",
        lg: "18px",
        xl: "24px",
        pill: "999px",
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "-apple-system", "Segoe UI", "Roboto", "Arial", "sans-serif"],
      },
      boxShadow: {
        "ecp-sm": "0 6px 18px rgba(0,0,0,0.25)",
        "ecp-md": "0 10px 30px rgba(0,0,0,0.33)",
        "ecp-lg": "0 16px 60px rgba(0,0,0,0.40)",
        "ecp-lime": "0 0 0 4px rgba(183,255,42,0.20)",
      },
      transitionDuration: {
        fast: "140ms",
        base: "200ms",
        slow: "260ms",
      },
      transitionTimingFunction: {
        standard: "cubic-bezier(0.2,0.8,0.2,1)",
      },
    },
  },
};
export default config;
```

---

## ANDROID — NativeWind / React Native

```typescript
// packages/shared/src/constants/tokens.android.ts
export const tokens = {
  colors: {
    bg: "#0b0f14",
    surface: "#121b27",
    surface2: "#0f1620",
    border: "rgba(39,54,74,0.45)",
    text: "#eaf2ff",
    textSecondary: "#a9b7cc",
    muted: "#7b8aa3",
    lime: "#b7ff2a",
    limeHover: "#9eea12",
    limePressed: "#7ed100",
    limeGlow: "rgba(183,255,42,0.20)",
    success: "#3dff8b",
    warning: "#ffcc00",
    danger: "#ff4d4d",
    info: "#4da3ff",
  },
  radius: {
    card: 18,
    control: 14,
    pill: 999,
  },
  spacing: {
    pad: 16,
    gap: 12,
    topBar: 56,
    bottomNav: 72,
  },
  typography: {
    screenTitle: { fontSize: 20, fontWeight: "700" as const },
    cardTitle: { fontSize: 14, fontWeight: "700" as const },
    body: { fontSize: 14 },
    caption: { fontSize: 12 },
  },
} as const;
```

---

## iOS — React Native / Expo

```typescript
// packages/shared/src/constants/tokens.ios.ts
export const tokens = {
  colors: {
    background: "#0b0f14",
    secondaryBackground: "#0f1620",
    elevatedSurface: "#131c28",
    separator: "rgba(39,54,74,0.40)",
    textPrimary: "#eaf2ff",
    textSecondary: "#a9b7cc",
    textTertiary: "#7b8aa3",
    lime: "#b7ff2a",
    limePressed: "#7ed100",
    limeGlow: "rgba(183,255,42,0.20)",
    success: "#3dff8b",
    warning: "#ffcc00",
    danger: "#ff4d4d",
    info: "#4da3ff",
  },
  radius: {
    card: 18,
    control: 13,
  },
  spacing: {
    margin: 16,
    cardGap: 12,
  },
  typography: {
    largeTitle: { fontSize: 30, fontWeight: "700" as const },
    title: { fontSize: 20, fontWeight: "600" as const },
    body: { fontSize: 16 },
    caption: { fontSize: 12 },
  },
} as const;
```
