---
name: bundle-optimizer
description: >
  Otimizar bundle Next.js com dynamic imports, code splitting e análise de dependências. Use quando o build size aumentar além do esperado, quando Core Web Vitals piorarem, ou ao adicionar bibliotecas pesadas.
---

# Skill: bundle-optimizer

## Objetivo
Otimizar bundle Next.js para carregamento rápido e Core Web Vitals positivos.

## Estratégias
```tsx
// ✅ Dynamic import para componentes pesados
const HeavyChart = dynamic(() => import("./heavy-chart"), {
  loading: () => <Skeleton className="h-64 w-full" />,
  ssr: false,
});

// ✅ Image otimização via Next.js Image
import Image from "next/image";
<Image src="/logo.png" alt="Logo" width={200} height={50} priority />

// ✅ Font otimização via Next.js Font
import { Inter } from "next/font/google";
const inter = Inter({ subsets: ["latin"] });
```

## Análise de Bundle
```bash
# Analisar bundle size
ANALYZE=true pnpm build
```
