# Skill — user-story-writer

## Objetivo
Redigir histórias de usuário no formato padrão com contexto e valor claro.

## Formato
```
Como [persona/papel]
Eu quero [ação ou capacidade]
Para que [benefício ou objetivo]
```

## Input
```json
{ "feature": "...", "persona": "...", "hipotese_de_solucao": "..." }
```

## Output
```json
{
  "id": "US-001",
  "feature_pai": "FT-001",
  "titulo": "...",
  "descricao": "Como [persona] eu quero [ação] para que [benefício]",
  "estimativa": "P | M | G | GG",
  "prioridade": 1,
  "criterios_de_aceite": []
}
```
