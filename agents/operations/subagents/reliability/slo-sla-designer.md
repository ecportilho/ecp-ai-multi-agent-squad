# Skill: slo-sla-designer

## Objetivo
Definir SLOs realistas e error budgets para o projeto.

## SLOs Base
```json
{
  "slos": [
    {
      "name": "API Availability",
      "target": "99.9%",
      "measurement": "Uptime Vercel / Sentry error rate",
      "error_budget_monthly_minutes": 43
    },
    {
      "name": "tRPC P95 Latency",
      "target": "< 500ms",
      "measurement": "New Relic trace percentile"
    },
    {
      "name": "Error Rate",
      "target": "< 0.5%",
      "measurement": "Sentry errors / total requests"
    },
    {
      "name": "Build Success Rate CI",
      "target": "95%",
      "measurement": "GitHub Actions success rate"
    }
  ]
}
```

## Error Budget
- Error budget = 100% - SLO target
- 99.9% availability → 0.1% budget = ~43 min/mês
- Consumir error budget → congelar features, priorizar reliability
