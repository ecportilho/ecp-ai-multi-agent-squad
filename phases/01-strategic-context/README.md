# Fase 01 — Contexto Estratégico

## Objetivo
Definir OKRs e Opportunity Solution Tree (OST) com oportunidades macro (dores, necessidades e desejos) ligadas aos KRs. Nenhuma solução ou feature nesta fase.

## Input Primário
**`{REPO_DESTINO}/product_briefing_spec.md`** — escopo funcional, regras de negócio e contexto do produto.

## Agente
**Product Manager Agent** (`agents/product-manager/`)

## Fluxo Interno
1. Market Research Agent → evidências de mercado (baseado no product_briefing_spec.md)
2. Product Vision Agent → objetivo e princípios
3. Product Strategy Agent → KRs + mapeamento de oportunidades
4. Metrics Agent → validar mensurabilidade dos KRs

## Output Esperado
- Objetivo do produto (inspirador, 3-5 anos)
- 2-3 OKRs com KRs mensuráveis e baseline
- OST completa: oportunidades por KR (dores, necessidades, desejos)
- Princípios de produto
- Opportunity Brief

## Checkpoint — HITL #1
**Quem revisa:** Product Owner + Stakeholders
**Perguntas centrais:**
- O objetivo é inspirador e claro?
- Os KRs são mensuráveis e alcançáveis?
- As oportunidades estão ligadas aos KRs corretos?
- Há soluções disfarçadas de oportunidades?
- **Regra de ouro Torres:** nenhuma solução nesta fase

**Decisões possíveis:**
- ✅ Aprovado → Avançar para Fase 02 (Product Discovery)
- ⚠️ Aprovado com ressalvas → Avançar com restrições documentadas
- ❌ Reprovado → Retornar ao PM Agent com feedback específico

## Arquivo de Output
`{REPO_DESTINO}/01-strategic-context/`
