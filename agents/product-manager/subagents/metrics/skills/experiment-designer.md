# Skill — experiment-designer

## Objetivo
Estruturar experimentos para testar suposições com critérios de sucesso claros.

## Input
```json
{ "suposicao": "...", "metrica_alvo": "...", "baseline": "..." }
```

## Output
```json
{
  "hipotese": "Se [ação], então [resultado] porque [razão]",
  "metrica": "...",
  "criterio_de_sucesso": "...",
  "duracao": "...",
  "tamanho_amostral": "...",
  "como_executar": "..."
}
```
