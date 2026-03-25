---
name: incident-commander
description: >
  Conduzir resposta estruturada a incidentes: detecção, contenção, resolução e comunicação.
  Use imediatamente ao detectar incidente de produção — coordena o processo até a resolução e handoff para postmortem.
---

# Skill: incident-commander

## Objetivo
Conduzir resposta a incidentes com timeline estruturada, comunicação clara e resolução eficaz —
minimizando MTTR e protegendo o error budget do produto.

## Severidades

| Severity | Critério | SLA de Resposta | Comunicação |
|----------|---------|----------------|-------------|
| **P0 — Crítico** | Produto indisponível ou perda de dados | 15 min | Todos os stakeholders |
| **P1 — Alto** | Feature crítica degradada (Pix, auth) | 30 min | Time técnico + PO |
| **P2 — Médio** | Degradação de performance ou feature não crítica | 2h | Time técnico |
| **P3 — Baixo** | Bug cosmético ou edge case raro | Próximo sprint | Log apenas |

## Runbook de Resposta

### PASSO 1 — Detecção e Classificação (0-5 min)
```
1. Confirmar o incidente — reproduzir ou verificar alertas Sentry/New Relic
2. Classificar severidade (P0/P1/P2/P3)
3. Abrir canal de incidente (Slack #incidents ou similar)
4. Anunciar: "Incidente P[N] detectado em [componente]. Investigando."
5. Registrar timestamp de início
```

### PASSO 2 — Contenção (5-20 min)
```
Verificar em ordem:
□ Deploy recente? → Rollback imediato via Vercel Dashboard
□ Feature flag ativa? → Desativar no PostHog
□ Spike de tráfego? → Verificar rate limiting Upstash
□ Erro de banco? → Verificar conexões Supabase Dashboard
□ Erro de terceiro? → Status page do serviço (Supabase, Vercel, Upstash)
```

**Rollback Vercel (Windows-safe):**
```
Vercel Dashboard → Deployments → selecionar último deploy estável → Promote to Production
```

### PASSO 3 — Diagnóstico (durante contenção)
```typescript
// Queries úteis no Supabase Dashboard → SQL Editor
-- Verificar últimas transações com erro
SELECT * FROM transactions 
WHERE status = 'FAILED' AND created_at > NOW() - INTERVAL '1 hour'
ORDER BY created_at DESC LIMIT 20;

// Sentry: filtrar por fingerprint do erro para ver volume e primeiros casos
// New Relic: NRQL para latência por endpoint
SELECT average(duration) FROM Transaction 
WHERE appName = 'ecp-web' SINCE 30 minutes ago FACET name
```

### PASSO 4 — Resolução
```
1. Aplicar fix ou manter rollback como resolução temporária
2. Verificar que o sintoma desapareceu nos dashboards
3. Confirmar com usuário afetado se possível
4. Anunciar resolução: "Incidente P[N] resolvido às [hora]. Causa: [resumo]. Postmortem em [prazo]."
5. Registrar timestamp de resolução → calcular MTTR
```

### PASSO 5 — Handoff para Postmortem
```
Registrar no artefato do incidente:
- Timeline completa (detecção → contenção → resolução)
- Causa raiz preliminar
- Ações tomadas
- Impacto estimado (usuários afetados, transações perdidas/atrasadas)
- Prazo para postmortem completo (máx 48h para P0/P1)
→ Acionar: blameless-postmortem-writer
```

## Comunicação por Severidade

### P0/P1 — Template de update a cada 15 min
```
[HH:MM] Status: Investigando | Contendo | Resolvendo
Impacto: [o que está afetado]
Ação atual: [o que estamos fazendo agora]
Próximo update em: 15 min
```

## Métricas MTTR
Registrar no `quality-metrics` após cada incidente:
- **MTTR** = timestamp_resolução - timestamp_detecção
- Meta: MTTR P0 < 1h, P1 < 4h
