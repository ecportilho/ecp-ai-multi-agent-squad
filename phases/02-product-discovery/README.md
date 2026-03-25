# Fase 02 — Product Discovery

## Objetivo
Priorizar oportunidades, idear soluções, prototipar e validar antes de construir.
Avaliar os 4 riscos de Cagan: Valor, Usabilidade, Viabilidade e Viabilidade de Negócio.

## Inputs
- **`{REPO_DESTINO}/product_briefing_spec.md`** — regras de negócio e funcionalidades
- **`{REPO_DESTINO}/design_spec.md`** — identidade visual (usado apenas no protótipo high-fi)
- **Output da Fase 01** — OKRs, OST e princípios aprovados

## Agentes
- **Product Owner** → priorização (antes) e estruturação (depois)
- **Product Designer** → ideação + protótipos low-fi e high-fi
- **Product Manager** → participa da avaliação dos 4 riscos

## Fluxo Interno

### Momento 1 — Priorização
PO recebe a OST da Fase 01 e prioriza oportunidades.
**HITL #2** — Oportunidades certas priorizadas?

### Momento 2 — Ideação
Designer sintetiza evidências e gera hipóteses de solução.
**HITL #3** — Hipóteses aprovadas para prototipar?

### Momento 3 — Protótipo Low-Fi (Wireframe)
Designer cria protótipo wireframe em **arquivo HTML único**.
- **Formato:** wireframe neutro, sem identidade visual
- **Foco:** mitigar **Risco de Valor para o Cliente**
- **Output:** `{REPO_DESTINO}/02-product-discovery/prototype/low-fi.html`
- **Skill:** `agents/product-designer/subagents/ux/skills/low-fi-prototyper.md`

**HITL #4** — Conceito validado? Risco de valor mitigado?

### Momento 4 — Protótipo High-Fi
Designer cria protótipo completo em **arquivo HTML único**.
- **Formato:** identidade visual do `design_spec.md`, 100% funcional e navegável
- **Foco:** mitigar **Risco de Usabilidade** + **Risco de Valor**
- **Output:** `{REPO_DESTINO}/02-product-discovery/prototype/high-fi.html`
- **Skill:** `agents/product-designer/subagents/ux/skills/high-fi-prototyper.md`

**HITL #5** — Usabilidade validada? Identidade visual correta?

### Momento 5 — Estruturação + 4 Riscos
PO estrutura épicos, features e histórias. Trio PM+Designer+PO avalia os 4 riscos.
**HITL #6** — 4 riscos aprovados? Pronto para Delivery?

## Output Esperado
- Oportunidades priorizadas
- Hipóteses de solução
- Protótipo low-fi wireframe (HTML único)
- Protótipo high-fi com identidade visual (HTML único)
- Épicos, features e histórias em BDD/Gherkin
- Avaliação dos 4 riscos

## Arquivo de Output
`{REPO_DESTINO}/02-product-discovery/`
