---
name: dependency-audit
description: >
  Mapear dependências externas, avaliar riscos de acoplamento e recomendar substituições ou monitoramento. Use ao adicionar novas bibliotecas, ao revisar o package.json, ou ao planejar atualizações de versão.
---

# Skill: dependency-audit

## Objetivo
Mapear dependências externas e avaliar riscos de acoplamento no o produto.

## Output
```json
{
  "dependencies": [
    {
      "name": "",
      "version": "",
      "type": "runtime | dev",
      "risk": "high | medium | low",
      "last_updated": "",
      "alternatives": [],
      "recommendation": "keep | replace | monitor"
    }
  ]
}
```
