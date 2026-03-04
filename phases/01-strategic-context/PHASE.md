# Fase 01 — Contexto Estratégico

## Objetivo
Definir o Objetivo, os KRs e as Oportunidades Macro (Dores, Necessidades e Desejos)
que compõem o topo da Opportunity Solution Tree (OST) de Teresa Torres.

## Agente Responsável
`product-manager`

## O que esta fase produz
- Objetivo claro e inspirador para o produto
- KRs mensuráveis e alcançáveis ligados ao objetivo
- Oportunidades Macro por KR (Dores, Necessidades e Desejos dos clientes)
- Leading indicators para cada KR

## O que NÃO deve aparecer nesta fase
- Features ou funcionalidades
- Soluções técnicas
- Wireframes ou referências visuais
- Histórias de usuário

## HITL #1 — Perguntas para o Humano
1. O Objetivo é inspirador e orienta decisões de produto?
2. Os KRs são mensuráveis e alcançáveis no prazo definido?
3. As Oportunidades Macro estão ligadas aos KRs corretos?
4. São oportunidades reais (dores/necessidades/desejos) ou soluções disfarçadas?
5. O escopo está adequado para um ciclo de discovery?

## Output Esperado (salvo em /shared/outputs/01-strategic-context/)
```json
{
  "objetivo": "...",
  "krs": [
    {
      "id": "KR1",
      "descricao": "...",
      "metrica": "...",
      "baseline": "...",
      "meta": "...",
      "prazo": "...",
      "oportunidades": [
        { "tipo": "dor | necessidade | desejo", "descricao": "..." }
      ],
      "leading_indicators": []
    }
  ]
}
```

## Decisão HITL #1
- ✅ Aprovado → avançar para Fase 02 (product-owner, priorização)
- ⚠️ Aprovado com ressalvas → avançar com restrições documentadas
- ❌ Reprovado → retornar ao product-manager com feedback
