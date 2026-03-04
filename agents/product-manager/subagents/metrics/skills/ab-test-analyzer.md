# Skill — ab-test-analyzer

## Objetivo
Monitorar KRs por variação do A/B em produção e identificar variação vencedora.

## Input
```json
{
  "variante_a": { "descricao": "...", "metricas": {} },
  "variante_b": { "descricao": "...", "metricas": {} },
  "criterio_de_sucesso": "...",
  "duracao_dias": 0
}
```

## Output
```json
{
  "vencedor": "A | B | inconclusivo",
  "confianca_estatistica": "...",
  "impacto_nos_krs": [],
  "aprendizados": "...",
  "recomendacao": "rollout_a | rollout_b | continuar_teste | retornar_discovery"
}
```

## Passos
1. Comparar métricas entre variantes A e B
2. Calcular significância estatística (mínimo 95% de confiança)
3. Avaliar impacto nos KRs definidos pelo PM
4. Documentar aprendizados independente do resultado
5. Recomendar próximo passo com justificativa
