# Skill: ab-test-analyzer

## Objetivo
Analisar resultados do A/B testing em produção, identificar variação vencedora e recomendar ação de retroalimentação.

## Input
```json
{
  "ab_test_id": "",
  "variant_a_metrics": {},
  "variant_b_metrics": {},
  "okrs": [],
  "duration_days": 0,
  "sample_size": 0
}
```

## Output
```json
{
  "winner": "A | B | none",
  "statistical_significance": true,
  "kr_impact": {
    "kr_01": { "variant_a": 0, "variant_b": 0, "delta": 0 }
  },
  "learning": "",
  "recommendation": "rollout_winner | extend_test | revisit_discovery | revisit_strategy | fix_technical",
  "retroalimentacao": {
    "needed": true,
    "to_phase": "02-product-discovery | 01-strategic-context | 03-product-delivery",
    "reason": ""
  }
}
```

## Passos
1. Verificar validade estatística do teste
2. Comparar impacto de cada variante nos KRs
3. Identificar a variante vencedora ou ausência de diferença
4. Sintetizar o aprendizado gerado
5. Recomendar ação: rollout, novo ciclo de discovery ou retorno estratégico
