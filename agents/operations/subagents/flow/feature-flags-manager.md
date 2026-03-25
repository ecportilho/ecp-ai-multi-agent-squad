---
name: feature-flags-manager
description: >
  Gerenciar feature flags no PostHog para releases graduais, A/B testing e rollback seguro. Use ao preparar qualquer deploy que precise de rollout controlado ou teste de variação.
---

# Skill: feature-flags-manager

## Objetivo
Gerenciar feature flags para A/B testing e rollouts controlados.

## Opção 1 — PostHog Feature Flags (recomendado)
```typescript
// PostHog já está na stack para analytics
// Feature flags integradas sem custo adicional
import { usePostHog } from "posthog-js/react";

export function useFeatureFlag(flag: string) {
  const posthog = usePostHog();
  return posthog.isFeatureEnabled(flag);
}
```

## Opção 2 — Arquivo JSON local (simples)
```json
{
  "flags": {
    "new_pix_flow": {
      "enabled": true,
      "rollout_percentage": 50,
      "description": "Novo fluxo de pagamento Pix"
    }
  }
}
```

## A/B Testing com PostHog
```typescript
// Criar experimento no PostHog Dashboard
// Variantes: control (A) e test (B)
// PostHog atribui usuários automaticamente por user ID hash
// Métricas rastreadas via eventos PostHog
```

## Critérios de Rollout
- 5% → checar erros no Sentry e métricas no New Relic
- 20% → validar conversion rate no PostHog
- 50% → A/B test formal (2 semanas mínimo)
- 100% → rollout completo + remover flag do código
