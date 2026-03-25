---
name: continuous-interview-partner
description: >
  Estruturar e sintetizar cadência semanal de entrevistas com usuários para validar oportunidades da OST. Use sempre que houver oportunidade nova ou refinamento de hipótese na Fase 02 de Discovery.
---

# Skill: continuous-interview-partner

## Objetivo
Estruturar e sintetizar cadência semanal de entrevistas com usuários do o produto.

## Input
```json
{ "opportunity": "", "assumptions_to_probe": [], "interview_count": 5 }
```

## Output
```json
{
  "interview_guide": {
    "objective": "",
    "opening": "",
    "questions": [],
    "probing_techniques": []
  },
  "synthesis": {
    "patterns": [],
    "surprises": [],
    "quotes": [],
    "opportunity_validation": "confirmed | rejected | refined"
  }
}
```

## Passos
1. Definir objetivo da rodada de entrevistas
2. Criar roteiro baseado em oportunidade e suposições
3. Aplicar técnica de entrevista exploratória (não perguntar sobre solução)
4. Sintetizar padrões e insights
5. Atualizar status da oportunidade na OST

## Regras
- Nunca perguntar "você usaria X?" — sempre explorar comportamento passado
- Mínimo 5 entrevistas por rodada para identificar padrões
