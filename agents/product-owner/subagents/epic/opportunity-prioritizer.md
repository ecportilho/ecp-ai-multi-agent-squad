---
name: opportunity-prioritizer
description: >
  Priorizar oportunidades da OST por impacto nos KRs usando RICE, Kano ou matriz de valor vs esforço. Use no Momento 1 da Fase 02 para selecionar quais oportunidades entram no ciclo atual.
---

# Skill: opportunity-prioritizer

## Objetivo
Priorizar oportunidades da OST por impacto nos KRs, evidências disponíveis e viabilidade.

## Input
```json
{ "ost": {}, "okrs": [], "constraints": [] }
```

## Output
```json
{
  "prioritized_opportunities": [
    {
      "opp_id": "opp-01",
      "description": "",
      "kr_targeted": "kr-01",
      "priority_score": 0,
      "rationale": "",
      "status": "attack_now | attack_later | discard",
      "evidence_confidence": "high | medium | low"
    }
  ],
  "attack_now": [],
  "attack_later": [],
  "discarded": []
}
```

## Passos
1. Listar todas as oportunidades da OST
2. Para cada uma, avaliar impacto nos KRs (1-10)
3. Avaliar confiança nas evidências (1-10)
4. Avaliar esforço de discovery (1-10, menor = melhor)
5. Calcular score: (impacto × confiança) / esforço
6. Classificar em attack_now / attack_later / discard
