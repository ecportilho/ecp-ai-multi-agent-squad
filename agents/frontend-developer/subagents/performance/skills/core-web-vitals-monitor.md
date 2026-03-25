---
name: core-web-vitals-monitor
description: >
  Medir e otimizar LCP (< 2.5s), CLS (< 0.1) e INP (< 200ms) no Next.js.
  Use antes do HITL #9, ao receber alertas de performance, ou ao revisar qualquer rota crítica do produto.
---

# Skill: core-web-vitals-monitor

## Objetivo
Medir e otimizar LCP (< 2.5s), CLS (< 0.1) e INP (< 200ms) no Next.js — requisitos
obrigatórios para aprovação no HITL #9.

## Thresholds Obrigatórios

| Métrica | Bom | Precisa melhorar | Ruim |
|---------|-----|-----------------|------|
| **LCP** — Largest Contentful Paint | < 2.5s | 2.5s – 4s | > 4s |
| **CLS** — Cumulative Layout Shift | < 0.1 | 0.1 – 0.25 | > 0.25 |
| **INP** — Interaction to Next Paint | < 200ms | 200ms – 500ms | > 500ms |

## Como Medir

### 1. Vercel Speed Insights (automático em produção)
```tsx
// apps/web/src/app/layout.tsx
import { SpeedInsights } from "@vercel/speed-insights/next";

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <SpeedInsights />
      </body>
    </html>
  );
}
```

### 2. Chrome DevTools — Lighthouse
```bash
# Rodar Lighthouse em modo incógnito para resultado limpo
# DevTools > Lighthouse > Performance > Analyze page load
# Focar em: LCP element, CLS shifts, INP interactions
```

### 3. Web Vitals no código (debugging)
```tsx
// apps/web/src/app/layout.tsx
"use client";
import { useReportWebVitals } from "next/web-vitals";

export function WebVitalsReporter() {
  useReportWebVitals((metric) => {
    if (process.env.NODE_ENV === "development") {
      console.log(metric); // debugging local
    }
    // Em produção: enviar para PostHog ou New Relic
  });
  return null;
}
```

## Correções por Métrica

### LCP (Largest Contentful Paint)
```tsx
// ✅ Preload da imagem hero
<Image src="/hero.jpg" priority alt="Hero" width={1200} height={600} />

// ✅ Font preload automático via next/font
import { Inter } from "next/font/google";
const inter = Inter({ subsets: ["latin"], display: "swap" });

// ❌ Evitar: imagens grandes sem next/image
// ❌ Evitar: fontes carregadas via CSS @import
```

### CLS (Cumulative Layout Shift)
```tsx
// ✅ Reservar espaço para imagens
<Image src="/logo.png" width={200} height={50} alt="Logo" />

// ✅ Skeleton com dimensões exatas
<Skeleton className="h-[200px] w-full" /> // altura fixa, não "auto"

// ❌ Evitar: img sem width/height
// ❌ Evitar: conteúdo inserido acima do fold após carregamento
```

### INP (Interaction to Next Paint)
```tsx
// ✅ Debounce em inputs de busca
const debouncedSearch = useDebouncedCallback(handleSearch, 300);

// ✅ startTransition para atualizações não urgentes
import { startTransition } from "react";
startTransition(() => setFilter(newFilter));

// ❌ Evitar: handlers síncronos pesados no thread principal
```

## Checklist pré-HITL #9
- [ ] LCP < 2.5s nas rotas principais (home, extrato, pix)
- [ ] CLS < 0.1 em todas as rotas com imagens ou skeletons
- [ ] INP < 200ms em todos os elementos interativos críticos
- [ ] Speed Insights configurado e enviando dados
- [ ] Lighthouse Score > 90 em mobile
