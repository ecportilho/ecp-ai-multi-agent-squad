# Skill — assumption-mapper

## Objetivo
Mapear e priorizar suposições críticas por risco e importância antes de construir.

## Input
```json
{ "hipoteses": [], "contexto": "..." }
```

## Output
```json
{
  "suposicoes": [
    {
      "descricao": "...",
      "tipo": "valor | usabilidade | viabilidade | negócio",
      "risco": "alto | médio | baixo",
      "como_testar": "...",
      "prioridade": 1
    }
  ]
}
```

## Passos
1. Extrair suposições implícitas de cada hipótese
2. Classificar por tipo de risco (4 riscos de Cagan)
3. Avaliar probabilidade de estar errado e impacto se errado
4. Ordenar por prioridade de teste
5. Sugerir como testar cada suposição
