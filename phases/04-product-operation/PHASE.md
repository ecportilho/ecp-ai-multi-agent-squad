# Fase 04 — Operação de Produto

## Objetivo
Operar a aplicação com confiabilidade, monitorar KRs, executar A/B testing em produção
e retroalimentar o ciclo com aprendizados reais.

## Sequência de Agentes

### Etapa 1 — Operations (operations)
Configura pipeline, infraestrutura, SLOs e segurança.
→ HITL #11: Ambiente pronto? Deploy autorizado?

### Etapa 2 — Release
Aplicação vai a produção com feature flags configuradas para A/B.

### Etapa 3 — A/B Testing (operations + product-manager)
Operations configura split de tráfego via feature flags.
PM monitora KRs por variação e define critérios de sucesso.
→ HITL #12: Variação vencedora identificada? O que aprendemos?

## Retroalimentação — Decisões do HITL #12

| Resultado | Ação |
|-----------|------|
| ✅ Variação vence e move KRs | Rollout completo. PM atualiza baseline. Próximo ciclo. |
| ⚠️ Nenhuma variação move KRs | Retornar à Fase 02 — revisitar oportunidades e hipóteses |
| 🔴 KRs pioram | Retornar à Fase 01 — revisar OKRs e OST |
| 🔧 Variação vence com bug técnico | Retornar à Fase 03 — corrigir e nova rodada de A/B |

## Output Final (salvo em /shared/outputs/04-product-operation/)
```json
{
  "deploy": {
    "status": "success | failed",
    "environment": "...",
    "timestamp": "..."
  },
  "ab_test": {
    "variant_a": { "description": "...", "metrics": {} },
    "variant_b": { "description": "...", "metrics": {} },
    "winner": "A | B | inconclusive",
    "confidence": "alto | médio | baixo"
  },
  "learning": "...",
  "retroalimentar": "01 | 02 | 03 | nenhum",
  "instructions": "o que deve ser revisado"
}
```
