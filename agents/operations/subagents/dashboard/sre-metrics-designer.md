---
name: sre-metrics-designer
description: >
  Definir SLIs, SLOs e métricas técnicas de operação com New Relic, Sentry e Vercel. Use ao configurar alertas de produção, ao definir error budgets, ou ao preparar a seção SRE do dashboard.
---

# Skill: sre-metrics-designer

## Objetivo
Definir SLIs, SLOs e todas as métricas técnicas de operação — disponibilidade, latência, erros, throughput e DORA — conectando observabilidade com saúde real do produto.

## Princípio Central
SRE não é sobre monitorar servidores. É sobre garantir que o produto entrega valor de forma confiável.
Cada métrica técnica deve ter uma resposta clara: "o que faço quando isso sai do target?"

---

## 1. SLIs e SLOs

### 1.1 Definições

**SLI (Service Level Indicator):** a métrica que mede o comportamento do sistema.
**SLO (Service Level Objective):** a meta que o SLI deve atingir.
**Error Budget:** quanto "crédito de falha" sobra antes de violar o SLO.

### 1.2 SLOs do Produto

| SLI | Definição | SLO | Janela | Error Budget Mensal | Fonte |
|-----|-----------|-----|--------|--------------------|----|
| Disponibilidade da API | % de requests tRPC com status 2xx ou 4xx (não 5xx) | ≥ 99,5% | 30 dias | ~3,6 horas | New Relic |
| Latência p95 (API) | 95% das requests tRPC respondidas em menos de X ms | < 500ms | 7 dias | — | New Relic |
| Latência p99 (API) | 99% das requests respondidas | < 2.000ms | 7 dias | — | New Relic |
| Taxa de erros | % de requests com erro 5xx | < 0,5% | 24 horas | — | Sentry + New Relic |
| LCP (Web Vitals) | Largest Contentful Paint | < 2,5s | 7 dias | — | Vercel / CrUX |
| INP (Web Vitals) | Interaction to Next Paint | < 200ms | 7 dias | — | Vercel / CrUX |
| Disponibilidade Auth | % de logins bem-sucedidos / tentativas válidas | ≥ 99,9% | 30 dias | ~43 min | Sentry |
| Build CI Success Rate | % de builds de CI que passam | ≥ 95% | 7 dias | — | GitHub Actions |

### 1.3 Error Budget Policy
```
Error budget > 50% restante  → Deploy normal, features novas liberadas
Error budget 25%–50% restante → Revisão obrigatória antes de cada deploy
Error budget < 25% restante  → Freeze de features, foco em reliability
Error budget esgotado         → Incident war room, nenhum deploy até recuperar
```

---

## 2. Métricas de Infraestrutura

### 2.1 API — tRPC

| Métrica | O que medir | Alerta | Fonte |
|---------|------------|--------|-------|
| Throughput | requests/segundo por rota tRPC | < 10% do baseline | New Relic |
| Latência p50/p95/p99 | Percentis de resposta | p95 > 500ms | New Relic |
| Taxa de erro 5xx | Erros internos do servidor | > 0,5% | New Relic + Sentry |
| Taxa de erro 4xx | Erros de cliente (validação, auth) | > 5% — indica UX problema | New Relic |
| Rate limit hits | Requisições bloqueadas por Upstash | > 1% dos usuários/hora | Upstash |
| Procedures mais lentas | Top 5 tRPC procedures por latência | — | New Relic |
| Procedures com mais erros | Top 5 por taxa de erro | — | Sentry |

### 2.2 Banco de Dados — Supabase PostgreSQL

| Métrica | O que medir | Alerta | Fonte |
|---------|------------|--------|-------|
| Connection pool usage | % de conexões usadas (max: pgbouncer) | > 80% | Supabase Dashboard |
| Query time p95 | 95% das queries em menos de X ms | > 200ms | Supabase Dashboard |
| Queries lentas | Queries acima de 500ms | Qualquer ocorrência | Supabase Dashboard |
| Tamanho do banco | GB utilizados | > 80% do limite do plano | Supabase Dashboard |
| Row count por tabela | Crescimento das tabelas principais | — | Supabase Dashboard |
| Replication lag | Atraso na réplica de leitura | > 1s | Supabase Dashboard |

### 2.3 Cache — Upstash Redis

| Métrica | O que medir | Alerta | Fonte |
|---------|------------|--------|-------|
| Hit rate | % de leituras servidas pelo cache | < 70% — cache ineficiente | Upstash Dashboard |
| Miss rate | % que foi ao banco por não estar em cache | > 30% | Upstash Dashboard |
| Commands/dia | Total de comandos (limite free: 10K/dia) | > 8.000/dia | Upstash Dashboard |
| Latência média | Tempo de resposta do Redis | > 10ms | Upstash Dashboard |

### 2.4 Frontend — Vercel + Core Web Vitals

| Métrica | O que medir | SLO | Fonte |
|---------|------------|-----|-------|
| LCP | Largest Contentful Paint | < 2,5s | Vercel Analytics |
| INP | Interaction to Next Paint | < 200ms | Vercel Analytics |
| CLS | Cumulative Layout Shift | < 0,1 | Vercel Analytics |
| TTFB | Time to First Byte | < 800ms | Vercel Analytics |
| Build time | Duração do build no Vercel | < 3 min | Vercel Dashboard |
| Bundle size | Tamanho do JS enviado ao browser | < 200KB inicial | Vercel Build Output |

### 2.5 Erros — Sentry

| Métrica | O que medir | Alerta | Fonte |
|---------|------------|--------|-------|
| New errors | Erros nunca vistos antes | Qualquer novo | Sentry Alerts |
| Error volume | Total de erros no período | > 2x baseline | Sentry |
| Affected users | Usuários impactados por erros | > 1% dos ativos | Sentry |
| Crash-free rate | % de sessões sem crash | > 99,5% | Sentry |
| Top errors | Top 5 erros por frequência | — | Sentry |

---

## 3. Métricas DORA (DevOps Research and Assessment)

As 4 métricas que medem a saúde da engenharia:

| Métrica | Definição | Elite | High | Medium | Low | Fonte |
|---------|-----------|-------|------|--------|-----|-------|
| **Deployment Frequency** | Com que frequência fazemos deploy em produção | Múltiplos/dia | Diário-semanal | Semanal-mensal | Mensal+ | GitHub + Vercel |
| **Lead Time for Changes** | Tempo do commit até produção | < 1 hora | 1 dia | 1 semana | 1 mês | GitHub Actions |
| **Change Failure Rate** | % de deploys que causaram incidente | < 5% | 5–10% | 10–15% | > 15% | GitHub + PagerDuty |
| **Time to Restore** | Tempo para recuperar de um incidente | < 1 hora | < 1 dia | < 1 semana | > 1 semana | Incidentes |

### Como calcular cada DORA

```
Deployment Frequency:
  = total de deploys com sucesso no período / dias no período
  Fonte: Vercel API (deployments to production)

Lead Time:
  = timestamp do merge na main - timestamp do primeiro commit da branch
  Fonte: GitHub API (commits + deployments)

Change Failure Rate:
  = deploys que geraram rollback ou incidente / total de deploys
  Fonte: Vercel (rollbacks) + postmortems

Time to Restore:
  = timestamp de resolução do incidente - timestamp de detecção (Sentry alert)
  Fonte: Sentry Alerts + postmortems
```

---

## 4. Alertas e Runbooks

### 4.1 Matriz de Alertas

| Alerta | Condição | Severidade | Ação Imediata |
|--------|---------|-----------|--------------|
| API down | Disponibilidade < 99% por 5 min | 🔴 Crítico | Acionar on-call, verificar Vercel e Supabase |
| Alta latência | p95 > 2s por 10 min | 🟠 Alto | Verificar queries lentas no Supabase |
| Spike de erros | Taxa de erro > 2% por 5 min | 🟠 Alto | Verificar Sentry, último deploy |
| Cache sem hit | Hit rate < 50% por 1 hora | 🟡 Médio | Verificar Upstash, revisar TTLs |
| Error budget < 25% | — | 🟡 Médio | Reunião de reliability, freeze de features |
| Novo erro crítico | Erro nunca visto com > 10 ocorrências | 🟠 Alto | Verificar Sentry session replay |
| Build CI falhando | > 3 builds consecutivos falhando | 🟡 Médio | Verificar último merge, corrigir antes de novos PRs |

### 4.2 Runbook Básico — API Lenta

```markdown
## Runbook: API com Latência Alta (p95 > 500ms)

1. Verificar New Relic → quais procedures estão lentas?
2. Verificar Supabase Dashboard → queries lentas (> 200ms)?
3. Verificar Upstash → hit rate do cache caiu?
4. Verificar último deploy → mudança recente pode ter causado regressão?
5. Se query lenta identificada → adicionar índice ou otimizar query
6. Se último deploy causou → rollback no Vercel (1 clique)
7. Documentar no postmortem
```

---

## 5. Output da Skill

```json
{
  "slos": [
    {
      "name": "",
      "sli": "",
      "target": "",
      "window": "",
      "error_budget_monthly": "",
      "source": ""
    }
  ],
  "infrastructure_metrics": {
    "api": [],
    "database": [],
    "cache": [],
    "frontend": [],
    "errors": []
  },
  "dora": {
    "deployment_frequency": { "current": "", "target": "elite" },
    "lead_time": { "current": "", "target": "elite" },
    "change_failure_rate": { "current": "", "target": "elite" },
    "time_to_restore": { "current": "", "target": "elite" }
  },
  "alerts": [],
  "dashboard_widgets": []
}
```
