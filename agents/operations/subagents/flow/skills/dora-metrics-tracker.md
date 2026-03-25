---
name: dora-metrics-tracker
description: >
  Medir e melhorar as 4 métricas DORA: deployment frequency, lead time, MTTR e change failure rate. Use na Fase 04 para monitorar saúde do pipeline e identificar gargalos de entrega.
---

# Skill: dora-metrics-tracker

## Objetivo
Medir as 4 métricas DORA com GitHub Actions, Vercel e dados de incidentes.

## Métricas / Estratégias
- Deployment Frequency: contagem de deploys para produção via Vercel API
- Lead Time: timestamp do commit até deploy completo no Vercel
- Change Failure Rate: deploys revertidos / total deploys
- MTTR: tempo de detecção (Sentry) até resolução (deploy de fix)
