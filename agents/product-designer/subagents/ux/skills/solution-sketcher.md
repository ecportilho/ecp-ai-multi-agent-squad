---
name: solution-sketcher
description: >
  Esboçar conceitos de solução em baixa fidelidade para comunicar hipóteses antes da prototipação. Use na etapa de Ideação para tangibilizar hipóteses antes de investir em protótipo completo.
---

# Skill: solution-sketcher

## Objetivo
Esboçar conceitos de solução em baixa fidelidade para comunicar e validar a ideia rapidamente.

## Input
```json
{ "hypothesis": {}, "key_flows": [] }
```

## Output
```json
{
  "sketches": [
    {
      "flow": "nome do fluxo",
      "screens": [
        { "screen": "nome", "description": "o que aparece e por quê", "key_elements": [] }
      ]
    }
  ],
  "assumptions_to_validate": []
}
```

## Passos
1. Identificar os 2-3 fluxos mais críticos da hipótese
2. Esboçar cada tela descrevendo elementos e intenção
3. Listar as suposições que o esboço assume
4. Preparar para teste de conceito rápido
