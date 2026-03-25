# Fase 03 — Product Delivery

## Objetivo
Arquitetar, implementar e validar a qualidade do produto seguindo os protótipos e histórias aprovadas no Discovery.

## Inputs
- **`{REPO_DESTINO}/tech_spec.md`** — Stack, arquitetura e regras de código
- **`{REPO_DESTINO}/design_spec.md`** — Identidade visual para implementação do Front End
- **`{REPO_DESTINO}/product_briefing_spec.md`** — Regras de negócio para QA
- **Output da Fase 02** — Épicos, features, histórias, protótipos aprovados

## Agentes e Sequência
1. **Software Architect** — Domain design + contratos de API + ADRs (baseado no tech_spec.md)
2. **Back End Developer** — APIs + persistência (conforme tech_spec.md)
3. **Front End Developer** — Interface + integração (conforme tech_spec.md + design_spec.md)
4. **QA** — Qualidade, testes e relatório (cruzando ambos os specs)

## HITLs desta Fase
| HITL | Pós | Pergunta Central |
|------|-----|-----------------|
| #7 | Arquiteto | Arquitetura sólida? Contratos de API prontos? |
| #8 | Back End | APIs seguem contratos? Persistência correta? Testes passando? |
| #9 | Front End | Front integrado com back? Design fiel ao design_spec.md e ao protótipo high-fi? |
| #10 | QA | Qualidade aprovada? Pronto para operar? |

## Critérios de Qualidade Mínimos (HITL #10)
Definidos no `{REPO_DESTINO}/tech_spec.md` (seção de testes e thresholds).
Adicionalmente:
- Nenhum bug crítico ou blocker aberto
- Acessibilidade WCAG 2.1 AA aprovada
- Front End visualmente consistente com protótipo high-fi aprovado

## Stack
Definida integralmente no `{REPO_DESTINO}/tech_spec.md`.

## Arquivo de Output
`{REPO_DESTINO}/03-product-delivery/`
