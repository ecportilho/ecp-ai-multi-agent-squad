---
name: ideation-facilitator
description: >
  Gerar múltiplas hipóteses de solução para as oportunidades priorizadas da OST. Use no início da etapa de Ideação na Fase 02 para divergir antes de convergir em protótipo.
---

# Skill: ideation-facilitator

## Objetivo
Gerar múltiplas hipóteses de solução para cada oportunidade priorizada, sem comprometimento prematuro.

## Input
```json
{ "opportunities_prioritized": [], "research_insights": [], "constraints": [] }
```

## Output
```json
{
  "hypotheses": [
    {
      "hypothesis_id": "hyp-01",
      "opportunity_id": "opp-01",
      "description": "Acreditamos que [solução] irá [outcome] para [usuário]",
      "rationale": "",
      "assumptions": [],
      "effort_estimate": "low | medium | high",
      "potential_impact": "low | medium | high"
    }
  ],
  "recommended_to_prototype": ["hyp-01", "hyp-02"]
}
```

## Passos
1. Para cada oportunidade priorizada, gerar mínimo 3 hipóteses distintas
2. Explorar soluções radicalmente diferentes (não apenas variações)
3. Mapear suposições críticas de cada hipótese
4. Recomendar 1-2 hipóteses para prototipação com justificativa
