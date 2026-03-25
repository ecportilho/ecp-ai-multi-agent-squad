---
name: customer-segmentation
description: >
  Definir e caracterizar segmentos de clientes por comportamento, necessidade e jobs-to-be-done. Use na Fase 01 para identificar o segmento primário do produto e suas dores específicas.
---

# Skill: customer-segmentation

## Objetivo
Definir e caracterizar segmentos de clientes por comportamento, necessidade e contexto de uso.

## Input
```json
{ "product": "o produto", "research_data": {} }
```

## Output
```json
{
  "segments": [
    {
      "name": "",
      "description": "",
      "size_estimate": "",
      "primary_jobs_to_be_done": [],
      "pain_points": [],
      "current_solutions": [],
      "willingness_to_pay": "high | medium | low"
    }
  ],
  "primary_segment": "",
  "rationale": ""
}
```

## Passos
1. Identificar perfis de usuários do o produto (freelancer, time pequeno, time médio)
2. Mapear jobs-to-be-done por perfil
3. Identificar dores e necessidades por segmento
4. Recomendar segmento primário com justificativa
