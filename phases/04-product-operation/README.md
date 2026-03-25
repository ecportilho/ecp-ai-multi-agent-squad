# Fase 04 — Operação de Produto

## Objetivo
Operar o produto com confiabilidade, monitorar SLOs e executar A/B testing para retroalimentar o ciclo de produto.

## Inputs
- **`{REPO_DESTINO}/tech_spec.md`** — Stack de operações, deploy, CI/CD e ferramentas
- **`{REPO_DESTINO}/design_spec.md`** — Identidade visual para dashboard e documentação
- **Output da Fase 03** — Código implementado e qualidade aprovada

## Agentes e Sequência
1. **Operations** — Pipeline + infra + SLOs + segurança
2. **PM + Ops** — Feature flags + A/B testing + análise de resultados

## HITLs desta Fase
| HITL | Pós | Pergunta Central |
|------|-----|-----------------|
| #11 | Operations | Ambiente pronto? SLOs definidos? Deploy autorizado? |
| #12 | A/B Testing | Variação vencedora? KRs movidos? O que aprendemos? |

## A/B Testing e Retroalimentação
O A/B testing é o motor de aprendizado contínuo:

```
Resultado HITL #12
│
├── ✅ Variante vence + move KRs
│     → Rollout completo → próximo ciclo de Discovery
│
├── ⚠️ Nenhuma variante move KRs
│     → Retroalimentar Fase 02 (Discovery)
│     → PO revisita oportunidades priorizadas
│
├── 🔴 KRs pioram em ambas
│     → Retroalimentar Fase 01 (Estratégico)
│     → PM revisa OST e OKRs
│
└── 🔧 Problema técnico na variante vencedora
      → Retroalimentar Fase 03 (Delivery)
      → Dev corrige + novo ciclo de A/B
```

## SLOs
Definidos no `{REPO_DESTINO}/tech_spec.md` (seção de limites de performance/SLOs).

---

## Etapa Final — Geração de Documentação

Após HITL #12 aprovado, o Orquestrador aciona o Operations Agent para gerar o site de documentação.

### Output
```
{REPO_DESTINO}/docs/
├── index.html        # Visão geral do produto e timeline
├── fase-01.html      # Contexto Estratégico (OKRs, OST, Visão)
├── fase-02.html      # Discovery (Oportunidades, Épicos, Histórias, 4 Riscos)
├── fase-03.html      # Delivery (Domínio, ADRs, API, Qualidade)
├── fase-04.html      # Operação (SLOs, A/B, DORA, Próximos Passos)
└── assets/
    ├── style.css     # Identidade visual do design_spec.md
    └── nav.js
```

### Skill
`agents/operations/subagents/flow/docs-generator.md`

### Critério de Conclusão
Site abrindo via `file://`, com todos os artefatos das 4 fases, navegação funcional e identidade visual do `design_spec.md` aplicada.

### Guia de Instalação (`INSTALACAO.md`)
Gerado junto com a documentação. Skill: `agents/operations/subagents/flow/installation-guide-writer.md`

Output: `{REPO_DESTINO}/docs/INSTALACAO.md`

---

## Dashboard Operacional

Gerado pelo Operations Agent → Dashboard Agent após o primeiro deploy.

**Output:** `{REPO_DESTINO}/docs/dashboard/index.html`

**Seções:**
- Visão Geral — KPIs de produto e sistema em uma tela só
- Uso do Produto — DAU/MAU, retenção, adoção por feature, funnels
- Outcomes & KRs — progresso dos OKRs da Fase 01
- SRE & Técnico — SLOs, DORA, latência, erros, infra

**Skills:** `agents/operations/subagents/dashboard/`

## Arquivo de Output
`{REPO_DESTINO}/04-product-operation/`
