---
name: market-sizing
description: >
  Estimar TAM, SAM e SOM do mercado endereçável pelo produto com fontes documentadas. Use na Fase 01 para fundamentar decisões estratégicas e o contexto da OST.
---

# Skill: market-sizing

## Objetivo
Estimar o tamanho do mercado endereçável para o o produto.

## Input
```json
{ "product": "o produto", "geography": "string", "segment": "string" }
```

## Output
```json
{
  "tam": { "value": 0, "unit": "USD", "description": "" },
  "sam": { "value": 0, "unit": "USD", "description": "" },
  "som": { "value": 0, "unit": "USD", "description": "" },
  "sources": [],
  "confidence": "high | medium | low"
}
```

## Passos
1. Identificar o mercado total de ferramentas de gestão de tarefas (TAM)
2. Filtrar pelo segmento endereçável do o produto (SAM)
3. Estimar fatia realista dado estágio e recursos (SOM)
4. Documentar fontes e nível de confiança
