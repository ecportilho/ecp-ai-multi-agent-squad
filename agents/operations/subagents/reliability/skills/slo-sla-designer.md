# Skill — slo-sla-designer

## Objetivo
Definir SLOs e error budgets para o o produto.

## SLOs do o produto (local)
```json
{
  "slos": [
    {
      "servico": "API GET /boards",
      "slo": "99% das requisições em < 200ms",
      "janela": "30 dias",
      "error_budget": "1% = ~7.2h/mês"
    },
    {
      "servico": "Persistência JSON",
      "slo": "0 perdas de dados em operações normais",
      "janela": "contínuo"
    }
  ]
}
```
