---
name: trend-scanning
description: >
  Identificar movimentos de mercado e tecnologia relevantes para o produto nos próximos 1-3 anos. Use na Fase 01 para garantir que a estratégia está alinhada com o contexto de mercado.
---

# Skill: trend-scanning

## Objetivo
Identificar movimentos de mercado e tecnologia relevantes para o o produto.

## Input
```json
{ "horizon": "6_months | 1_year | 3_years", "focus": ["produtividade", "colaboração", "IA"] }
```

## Output
```json
{
  "trends": [
    {
      "name": "",
      "description": "",
      "relevance": "high | medium | low",
      "impact_on_product": "",
      "opportunity_or_threat": "opportunity | threat | both"
    }
  ]
}
```

## Passos
1. Identificar tendências em produtividade e gestão de tarefas
2. Avaliar impacto de IA em ferramentas de kanban
3. Analisar mudanças de comportamento de trabalho remoto/híbrido
4. Classificar por relevância e tipo de impacto
