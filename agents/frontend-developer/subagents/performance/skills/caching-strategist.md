---
name: caching-strategist
description: >
  Configurar estratégia de cache com fetch cache, Route Segment Config e Upstash Redis no Next.js.
  Use ao decidir estratégia de cache por rota, ao implementar ISR, ou ao otimizar dados frequentes com Redis.
---

# Skill: caching-strategist

## Objetivo
Configurar cache de dados com fetch cache, Route Segment Config e Upstash Redis para
dados frequentes — equilibrando frescor dos dados com performance de carregamento.

## Camadas de Cache no Next.js 15

### 1. Request Memoization (automático)
Requests idênticas na mesma render tree são deduplicadas automaticamente.
Não requer configuração — o Next.js faz isso por padrão.

### 2. Data Cache (fetch)
```tsx
// Dados que mudam raramente — cache por 1 hora
const data = await fetch("/api/config", {
  next: { revalidate: 3600 },
});

// Dados que nunca mudam — cache permanente
const data = await fetch("/api/static-content", {
  cache: "force-cache",
});

// Dados que mudam a cada request (sem cache)
const data = await fetch("/api/user-balance", {
  cache: "no-store",
});
```

### 3. Route Segment Config
```tsx
// app/(dashboard)/extrato/page.tsx
export const revalidate = 60;      // ISR: revalida a cada 60s
export const dynamic = "force-dynamic"; // sem cache (dados por usuário)
export const fetchCache = "force-no-store"; // força no-store em todos os fetches
```

### 4. Upstash Redis — Cache de Aplicação
```typescript
// packages/api/src/lib/redis.ts
import { Redis } from "@upstash/redis";

const redis = Redis.fromEnv();

// Padrão: cache de dados calculados (saldo, limites)
const CACHE_TTL = 60; // segundos

export async function getCachedBalance(userId: string) {
  const cacheKey = `balance:${userId}`;
  
  const cached = await redis.get<number>(cacheKey);
  if (cached !== null) return cached;

  const balance = await calculateBalance(userId); // operação cara
  await redis.setex(cacheKey, CACHE_TTL, balance);
  return balance;
}

// Invalidação após mutação
export async function invalidateBalanceCache(userId: string) {
  await redis.del(`balance:${userId}`);
}
```

## Decisão por Tipo de Dado

| Tipo de dado | Estratégia | TTL |
|-------------|-----------|-----|
| Configurações do sistema | fetch force-cache | Permanente (bust no deploy) |
| Conteúdo de marketing | revalidate | 1-24h |
| Dados de produto por usuário | no-store + Redis | 30-60s |
| Saldo e transações | no-store (real-time) | Sem cache |
| Limites e tarifas | Redis | 5min |

## Regras
- NUNCA cache em rotas que exibem saldo ou dados financeiros em tempo real
- Sempre invalidar Redis após mutações que afetam dados cacheados
- Verificar uso do free tier Upstash: 10K comandos/dia
- Preferir revalidate (ISR) sobre no-store sempre que possível para SEO
