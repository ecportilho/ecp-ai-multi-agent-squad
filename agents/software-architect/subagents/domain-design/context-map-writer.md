---
name: context-map-writer
description: >
  Mapear relacionamentos entre bounded contexts: integração, anti-corruption layer, conformist. Use após ubiquitous-language-builder para documentar como os contextos se comunicam.
---

# Skill: context-map-writer

## Objetivo
Documentar relações entre bounded contexts do o produto.

## Output
```json
{
  "context_map": [
    {
      "upstream": "User Management",
      "downstream": "Board Management",
      "relationship": "Customer-Supplier",
      "integration": "User ID referenciado em Board"
    },
    {
      "upstream": "Board Management",
      "downstream": "Card Management",
      "relationship": "Partnership",
      "integration": "Board contém Columns que contêm Cards"
    }
  ]
}
```
