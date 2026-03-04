# Skill: monitoring-setup

## Objetivo
Configurar observabilidade completa com Sentry, New Relic e PostHog.

## Sentry — Error Tracking
```typescript
// apps/web/sentry.client.config.ts
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 0.1,         // 10% das transactions em produção
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0, // 100% das sessions com erro
  integrations: [Sentry.replayIntegration()],
});
```

## New Relic — APM + Logs
```typescript
// apps/web/instrumentation.ts (OpenTelemetry)
export async function register() {
  if (process.env.NEXT_RUNTIME === "nodejs") {
    const { NodeSDK } = await import("@opentelemetry/sdk-node");
    // configurar New Relic via OpenTelemetry
  }
}
```

## PostHog — Product Analytics
```typescript
// Rastrear eventos de negócio
posthog.capture("payment_initiated", {
  amount_cents: 10050,
  method: "pix",
  userId: user.id,
});

// NUNCA rastrear PII: email, CPF, número de conta
```

## Alertas Recomendados
| Alerta | Threshold | Ferramenta |
|--------|-----------|-----------|
| Error rate | > 1% | Sentry |
| P95 latência tRPC | > 2s | New Relic |
| Apdex | < 0.85 | New Relic |
| Conversion drop | > 10% | PostHog |
