---
name: rendering-strategist
description: >
  Decidir e implementar a estratégia de renderização correta por rota: Server Component, Client Component, SSR ou SSG.
  Use ao criar novas rotas, ao diagnosticar hidratação lenta, ou ao revisar estratégia de renderização existente.
---

# Skill: rendering-strategist

## Objetivo
Decidir entre Server Component, Client Component e SSR/SSG por rota no Next.js 15 App Router,
garantindo a estratégia ideal para performance e experiência do usuário.

## Árvore de Decisão

```
Precisa de interatividade (onClick, onChange, useState)?
├── SIM → Client Component ("use client")
│   Precisa de dados do servidor também?
│   └── SIM → Server Component pai que passa dados como props para Client Component filho
└── NÃO → Server Component (padrão)
    │
    Os dados mudam com frequência?
    ├── SIM (real-time) → Server Component + Supabase Realtime no Client
    ├── SIM (por request) → Server Component com fetch sem cache
    └── NÃO → Server Component com revalidação (ISR ou time-based)
```

## Padrões por Tipo de Rota

### Páginas autenticadas (dados por usuário)
```tsx
// app/(dashboard)/extrato/page.tsx — Server Component
// Dados buscados no servidor, sem waterfall cliente
export default async function ExtratoPage() {
  const supabase = createServerClient();
  const { data: transactions } = await supabase
    .from("transactions")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(20);

  return <ExtratoList transactions={transactions} />;
}
```

### Componentes interativos
```tsx
// components/extrato/extrato-filter.tsx — Client Component
"use client";
import { useState } from "react";

export function ExtratoFilter({ onFilterChange }: Props) {
  const [period, setPeriod] = useState("30d");
  // interatividade aqui
}
```

### Rotas estáticas (landing, docs)
```tsx
// app/(public)/page.tsx
export const revalidate = 3600; // ISR: revalida a cada 1h

export default async function LandingPage() {
  // dados estáticos — gerados em build ou revalidados por tempo
}
```

## Regras do Next.js 15 App Router

| Regra | Detalhe |
|-------|---------|
| Default é Server Component | Nunca adicionar "use client" desnecessariamente |
| "use client" propaga para filhos | Componentes filhos de Client também são Client |
| Server Components não têm estado | useState, useEffect → Client obrigatório |
| Não passar funções como props de Server para Client | Serialização falha |
| Dados sensíveis ficam no servidor | Tokens, secrets, consultas DB nunca no Client |

## Anti-patterns

| ❌ Problema | ✅ Solução |
|-----------|----------|
| `"use client"` em todo arquivo por precaução | Server Component por padrão, Client só quando necessário |
| fetch no Client com useEffect (waterfall) | fetch no Server Component durante SSR |
| Props de função de Server para Client | Extrair lógica para Server Action ou API Route |
| Componente grande com "use client" por 1 button | Extrair só o button interativo como Client Component |
