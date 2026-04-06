# ECP AI Multi-Agent Squad — Definição Completa

> **Documento de referência** contendo todas as definições do squad: orquestrador, fases, HITLs, agentes, subagentes e skills.
>
> Gerado automaticamente a partir dos arquivos `CLAUDE.md` e `.md` de skills em `/agents/**`.

---

## Sumário

1. [Visão Geral](#1-visão-geral)
2. [Contrato de Entrada Obrigatório](#2-contrato-de-entrada-obrigatório)
3. [Schemas Compartilhados](#3-schemas-compartilhados)
4. [Orquestrador](#4-orquestrador)
5. [Fases e HITLs](#5-fases-e-hitls)
6. [Agentes, Subagentes e Skills](#6-agentes-subagentes-e-skills)
   - [🧑‍💼 Product Manager](#-product-manager)
   - [📋 Product Owner](#-product-owner)
   - [🎨 Product Designer](#-product-designer)
   - [🏛️ Software Architect](#️-software-architect)
   - [🔧 Back End Developer](#-back-end-developer)
   - [🤖 AI Engineer](#-ai-engineer)
   - [💻 Front End Developer](#-front-end-developer)
   - [🧪 QA](#-qa)
   - [⚙️ Operations Engineer](#️-operations-engineer)
7. [Resumo Estatístico](#7-resumo-estatístico)

---

## 1. Visão Geral

O **ECP AI Multi-Agent Squad** é um framework de orquestração de agentes de IA operado com **Human-in-the-Loop (HITL)**, organizado em 4 fases sequenciais com retroalimentação contínua via A/B testing em produção.

### Arquitetura

| # | Camada | Papel |
|---|--------|-------|
| 1 | **Orquestrador** | Coordena fases, delega aos agentes, gerencia HITLs, mantém estado em `context.json` |
| 2 | **Agentes** (9) | Especialistas em áreas do ciclo de produto (PM, PO, Designer, Architect, BE, FE, AI, QA, Ops) |
| 3 | **Subagentes** (39) | Especializações dentro de cada agente, com missão atômica |
| 4 | **Skills** (162+) | Capacidades idempotentes, definidas como arquivos Markdown |

### Regras Globais

- Nenhum agente inicia sem aprovação do HITL anterior
- Outputs registrados em `{REPO_DESTINO}/` por fase
- Estado da sessão em `/shared/memory/context.json`
- Somente o orquestrador toma decisões de fase
- Skills são atômicas e idempotentes
- Ambiente: **Windows** — nenhum comando Unix shell (`find`, `grep`, `ls`, `kill`) permitido
- Caminhos usam `/`, nunca `\`

### Referências Metodológicas

- **Torres** — Opportunity Solution Tree (OST)
- **Cagan** — 4 Riscos (valor, usabilidade, viabilidade, negócio)
- **SAFe 6.0** — Épico → Feature → História com BDD/Gherkin
- **Evans** — Domain-Driven Design
- **Fowler** — Evolutionary Architecture
- **Forsgren** — DORA metrics
- **Gene Kim** — DevOps Handbook
- **Google SRE Book** — SLOs, error budgets, blameless postmortems

---

## 2. Contrato de Entrada Obrigatório

O squad **não inicia** sem os 4 inputs abaixo validados:

| # | Input | Tipo | Descrição |
|---|-------|------|-----------|
| 1 | `product_briefing_spec.md` | Arquivo | Escopo funcional, regras de negócio, público-alvo e restrições |
| 2 | `tech_spec.md` | Arquivo | Stack, arquitetura, padrões e regras invioláveis de código |
| 3 | `design_spec.md` | Arquivo | Paleta, tipografia, tokens, componentes e diretrizes de design |
| 4 | **Repositório destino** | Path | Pasta onde TODOS os outputs do squad serão gravados |

### Estrutura esperada

```
{REPO_DESTINO}/
├── product_briefing_spec.md
├── tech_spec.md
└── design_spec.md
```

### Validação em duas camadas

1. **Script programático** — `validate-inputs.mjs` (Node.js, cross-platform) verifica existência e estrutura mínima
2. **Validação comportamental** — o orquestrador lê os 3 arquivos e valida seções obrigatórias

Se qualquer validação falhar, o squad **para e informa ao humano** o que falta.

### Seções Obrigatórias por Arquivo

**`product_briefing_spec.md`** — WHAT to build:
- Produto, Problema, Público-alvo, Contexto de negócio
- Funcionalidades principais, Regras de negócio, Restrições

**`tech_spec.md`** — HOW to build:
- Stack tecnológica, Arquitetura, Regras invioláveis
- Padrões de projeto, Deploy e infraestrutura, Testes

**`design_spec.md`** — WHAT FACE it has:
- Paleta de cores, Tipografia, Espaçamento e grid
- Componentes, Tema/Modo, Regra de ouro

---

## 3. Schemas Compartilhados

### `agent-contract.md` — Contrato de comunicação

**Input (Orquestrador → Agente):**
```json
{
  "phase": "01-strategic-context | 02-product-discovery | 03-product-delivery | 04-product-operation",
  "agent": "agent-name",
  "mission": "clear mission description",
  "context": { "key": "value" },
  "inputs_from_previous": { "previous outputs" },
  "hitl_feedback": "human feedback if returning after rejection"
}
```

**Output (Agente → Orquestrador):**
```json
{
  "status": "success | error | partial",
  "phase": "current phase",
  "agent": "agent name",
  "subagents_used": ["names"],
  "skills_used": ["skill names"],
  "deliverables": { "output objects" },
  "open_questions": ["questions"],
  "assumptions": ["assumptions"],
  "next_hitl": 1-12,
  "recommendation": "avançar | revisar | retornar"
}
```

**Aprovação HITL:**
```json
{
  "hitl": 1-12,
  "decision": "approved | rejected | approved_with_reservations",
  "feedback": "human comments",
  "next_agent": "next agent name",
  "constraints": ["any constraints"]
}
```

### `ost-schema.md` — Opportunity Solution Tree

Baseado em Teresa Torres:
- **Objetivo** (outcome de alto nível)
- **KRs** (mensuráveis, com baseline, target e frequência)
- **Oportunidades** (dores, necessidades, desejos ligados aos KRs)
- **Hipóteses de solução** (para cada oportunidade priorizada)
- **4 Riscos de Cagan**: Valor do Cliente, Valor do Negócio, Usabilidade, Viabilidade Técnica

---

## 4. Orquestrador

**Papel:** Agente central que coordena, delega, gerencia HITLs e garante fluxo entre as 4 fases. **Nunca executa tarefas diretamente** — apenas coordena.

### Responsabilidades

1. Receber demanda e identificar fase atual
2. Acionar agente correto com contexto completo
3. Apresentar outputs em checkpoints HITL
4. Transportar feedback humano ao agente correto
5. Gerenciar retroalimentação A/B (Fase 04)
6. Manter `/shared/memory/context.json` atualizado

### Fluxo (Regra Fundamental)

1. **Pre-flight** — validar 4 inputs obrigatórios (`node validate-inputs.mjs` + camada comportamental)
2. **Inicializar** `context.json` após validação
3. **Por fase:**
   1. Ler `context.json` → identificar agente da vez
   2. Preparar input completo (contexto + outputs anteriores)
   3. Acionar agente via Task
   4. Salvar output em `{REPO_DESTINO}/{fase}/`
   5. Apresentar ao humano (HITL)
   6. Aguardar decisão (approved / rejected / approved_with_reservations)
   7. Avançar ou retornar com feedback
   8. Atualizar `context.json`

### Estado da Sessão (`context.json`)

```json
{
  "session_id": "product-name-date",
  "product": "Product Name",
  "repo_destino": "absolute path",
  "inputs": {
    "product_briefing_spec": "path",
    "tech_spec": "path",
    "design_spec": "path"
  },
  "validation": "passed | failed",
  "current_phase": "01-strategic-context | ... | completed",
  "current_agent": "agent name or null",
  "current_hitl": 1-12,
  "hitl_pending": true | false,
  "phases_completed": ["phase names"],
  "last_approved_output": { "phase": "", "hitl": N, "decision": "approved" },
  "ab_tests": [{ "id": "", "name": "", "status": "...", "linked_krs": [] }],
  "retroalimentacao": { "trigger": "", "to_phase": "", "reason": "" } | null
}
```

### Retroalimentação (Fase 04 → Ciclo Anterior)

Após HITL #12, o resultado A/B determina o próximo passo:

- **KRs movem (vencedor claro)** → Rollout completo → Próximo ciclo
- **Sem movimento de KRs** → Retorna a **Fase 02** (repensar Discovery)
- **KRs pioram** → Retorna a **Fase 01** (repensar Estratégia)
- **Problema técnico** → Retorna a **Fase 03** (corrigir Delivery)

---

## 5. Fases e HITLs

### Mapa de Fases

```
FASE 01 — Contexto Estratégico
  → product-manager (market-research → product-vision → product-strategy → metrics)
  ↓ HITL #1

FASE 02 — Product Discovery
  → product-owner (epic) — priorizar oportunidades
  ↓ HITL #2
  → product-designer (customer-research + ux para ideação)
  ↓ HITL #3
  → product-designer (ux para low-fi)
  ↓ HITL #4
  → product-designer (ux + ui para high-fi)
  ↓ HITL #5
  → product-owner + product-designer + product-manager (4 riscos + backlog)
  ↓ HITL #6

FASE 03 — Product Delivery
  → software-architect
  ↓ HITL #7
  → backend-developer
  ↓ HITL #8
  → ai-engineer  ∥  frontend-developer  (paralelo)
  ↓ HITL #8.5 ↓ HITL #9
  → qa
  ↓ HITL #10

FASE 04 — Operação de Produto
  → operations
  ↓ HITL #11
  → product-manager (A/B analysis)
  ↓ HITL #12 (retroalimentação)
```

### Tabela de HITLs

| HITL | Fase | Pós-Agente | O que é validado | Decisão esperada |
|------|------|-----------|------------------|------------------|
| **#1** | 01 | PM | Objetivo inspirador, KRs mensuráveis, OST sem saltar para soluções | Aprovado → Fase 02 |
| **#2** | 02 | PO (priorização) | Oportunidades priorizadas alinhadas aos KRs | Aprovado → ideação |
| **#3** | 02 | Designer (ideação) | Hipóteses endereçam oportunidades; quais prototipar | Aprovado → low-fi |
| **#4** | 02 | Designer (low-fi) | Conceito validado; risco de valor mitigado | Aprovado → high-fi |
| **#5** | 02 | Designer (high-fi) | Usabilidade validada; identidade visual correta | Aprovado → backlog + 4 riscos |
| **#6** | 02 | PO + Designer + PM | 4 riscos endereçados; backlog estruturado | Aprovado → Fase 03 |
| **#7** | 03 | Architect | Bounded contexts, contratos de API, ADRs prontos | Aprovado → BE inicia |
| **#8** | 03 | Back End | APIs seguem contratos; persistência ok; testes passando | Aprovado → FE + AI paralelo |
| **#8.5** | 03 | AI Engineer | Soluções de IA integradas; guardrails ativos | Aprovado → FE integra IA |
| **#9** | 03 | Front End | Design fiel ao high-fi; Core Web Vitals ok; WCAG 2.1 AA | Aprovado → QA inicia |
| **#10** | 03 | QA | Cobertura ≥ thresholds; rastreabilidade AC→CT 100%; E2E P0 ok | Aprovado → Fase 04 |
| **#11** | 04 | Operations | Pipeline, SLOs, observabilidade, segurança prontos | Deploy autorizado |
| **#12** | 04 | PM (A/B) | Variação vencedora; aprendizados documentados | Rollout / Retro Fase 02 / Retro Fase 01 |

---

## 6. Agentes, Subagentes e Skills

### 🧑‍💼 Product Manager

**Fase:** 01 — Contexto Estratégico (e 04 — Análise A/B)

**Missão:** Especialista em estratégia de produto. Define OKRs, North Star, visão inspiradora e oportunidades da OST. Em Fase 04, monitora A/B e decide retroalimentação do ciclo.

**Inputs:**
- `{REPO_DESTINO}/product_briefing_spec.md`

**Outputs:**
- Objetivo e KRs com baseline/target/frequência
- Opportunity Solution Tree (OST) completa
- Visão de 3-5 anos
- Princípios de decisão do produto
- Análise dos 4 riscos de Cagan
- Recomendação de retroalimentação pós A/B

#### Subagente: `market-research`
**Missão:** Coletar e sintetizar evidências de mercado para fundamentar decisões estratégicas.

**Skills:**
- `market-sizing` — Estimar TAM, SAM e SOM com fontes documentadas
- `competitor-analysis` — Mapear concorrentes diretos/indiretos, gaps e posicionamento
- `trend-scanning` — Identificar movimentos de mercado e tecnologia em 1-3 anos
- `customer-segmentation` — Definir segmentos por comportamento, JTBD e dores

#### Subagente: `product-vision`
**Missão:** Definir visão de 3-5 anos, North Star Metric e princípios de decisão.

**Skills:**
- `vision-writer` — Redigir visão inspiradora que orienta sem prescrever soluções
- `north-star-definer` — Definir North Star e 3-5 métricas de input causais
- `product-principles` — Estabelecer 5-6 princípios que desempatam decisões
- `opportunity-brief-writer` — Documentar oportunidades com problema, evidências e hipóteses

#### Subagente: `product-strategy`
**Missão:** Estruturar OKRs, roadmap de outcomes e avaliar riscos estratégicos pré-HITL #6.

**Skills:**
- `okr-facilitator` — Definir OKRs com objetivo qualitativo e KRs mensuráveis
- `outcome-roadmap` — Construir roadmap de outcomes (não features) com now/next/later
- `four-risks-assessor` — Avaliar 4 riscos de Cagan por oportunidade priorizada
- `assumption-mapper` — Mapear e priorizar suposições críticas por risco

#### Subagente: `metrics`
**Missão:** Validar mensurabilidade dos KRs (Fase 01) e analisar resultados A/B (Fase 04).

**Skills:**
- `leading-lagging-indicators` — Separar métricas preditivas (leading) das de resultado (lagging)
- `experiment-designer` — Estruturar A/B tests com hipótese, critérios, amostra e parada
- `ab-test-analyzer` — Analisar resultados e recomendar rollout/discovery/strategy
- `report-generator` — Gerar relatórios com foco em outcomes e aprendizados

---

### 📋 Product Owner

**Fase:** 02 — Product Discovery (priorização + estruturação de backlog)

**Missão:** Traduzir oportunidades da OST em trabalho estruturado seguindo SAFe 6.0. Prioriza oportunidades, define épicos, features e histórias com critérios de aceite em Gherkin. Gera documentação funcional que é fonte de verdade para dev e QA.

**Inputs:**
- `{REPO_DESTINO}/product_briefing_spec.md`
- Protótipos high-fi aprovados (HITL #5)
- Mapa de fluxo do low-fi

**Outputs:**
- Oportunidades priorizadas com score RICE/Kano
- Épicos SAFe com hypothesis statement
- Features com benefit hypothesis e acceptance criteria
- Histórias de usuário completas (narrativa, RNs, campos, fluxos, ACs Gherkin)
- Documentação funcional por funcionalidade
- Story splitting para histórias > 5 pontos

#### Subagente: `epic`
**Missão:** Priorizar oportunidades por impacto nos KRs e estruturá-las em épicos SAFe.

**Skills:**
- `opportunity-prioritizer` — Priorizar por impacto/confiança/esforço; classificar em attack_now/attack_later/discard
- `opportunity-brief-writer` — Documentar oportunidades com contexto, evidências e outcome
- `epic-writer` — Redigir épicos com hypothesis statement, business outcome e ACs de portfolio
- `enabler-epic-writer` — Redigir épicos de habilitação técnica (arquitetura, infra, compliance)

#### Subagente: `feature`
**Missão:** Decompor épicos em features com benefit hypothesis e ACs de programa, com rastreabilidade.

**Skills:**
- `feature-writer` — Redigir features com benefit hypothesis e ACs em BDD, linked ao épico
- `enabler-feature-writer` — Features de habilitação técnica com time-box e dependências

#### Subagente: `story`
**Missão:** Gerar documentação funcional e escrever histórias de usuário testáveis em Gherkin.

**Skills:**
- `functional-documentation-writer` — Documentação de funcionalidade (RNs, campos, fluxos, estados, métricas)
- `user-story-writer` — Histórias com narrativa, contexto, fluxos principal/alternativo/exceção, DoR/DoD
- `acceptance-criteria-writer` — ACs Gherkin cobrindo happy path, alternativos, validações, RNs e erros
- `story-splitter` — Dividir histórias > 5 pontos em fatias verticais independentes

---

### 🎨 Product Designer

**Fase:** 02 — Product Discovery (ideação, low-fi, high-fi)

**Missão:** Conduzir research contínuo, ideação e prototipação. Gera hipóteses validadas em protótipos wireframe (low-fi) e alta fidelidade (high-fi) aplicando identidade visual do `design_spec.md`. Participa do trio PM+Designer+PO na avaliação dos 4 riscos.

**Inputs:**
- `{REPO_DESTINO}/product_briefing_spec.md`
- `{REPO_DESTINO}/design_spec.md` (apenas para high-fi)
- OST priorizada
- Feedback dos HITLs #3 e #4

**Outputs:**
- Hipóteses de solução para oportunidades priorizadas
- Protótipo wireframe low-fi navegável (HTML único)
- Mapa de fluxo com telas e transições
- Protótipo high-fi navegável 100% funcional (HTML único)
- Design tokens (CSS vars, Tailwind, NativeWind, RN)
- Component specs e responsive guidelines
- Auditoria WCAG 2.1 AA pré-HITL #5

#### Subagente: `customer-research`
**Missão:** Conduzir research contínuo e sintetizar insights validando oportunidades da OST.

**Skills:**
- `continuous-interview-partner` — Estruturar cadência semanal de entrevistas com ≥5 usuários
- `ethnographic-researcher` — Estudos de campo e shadowing para contexto real de uso
- `assumption-tester` — Testar suposições críticas com usuários reais antes de prototipar
- `insight-synthesizer` — Consolidar achados e conectar insights à OST

#### Subagente: `ux`
**Missão:** Conduzir ideação e criar protótipos wireframe e alta fidelidade navegáveis.

**Skills:**
- `ideation-facilitator` — Gerar ≥3 hipóteses distintas por oportunidade; recomendar 1-2 para prototipar
- `information-architecture` — Definir navegação, hierarquia e taxonomia antes do protótipo
- `solution-sketcher` — Esboçar conceitos em baixa fidelidade rapidamente
- `low-fi-prototyper` — Criar wireframe HTML navegável neutro (sem identidade visual)
- `high-fi-prototyper` — Criar protótipo HTML 100% fiel ao design_spec.md
- `interaction-design` — Especificar microinterações, estados e transições
- `usability-evaluator` — Avaliar com heurísticas de Nielsen; identificar friction points
- `accessibility-checker` — Auditar WCAG 2.1 AA: contraste, teclado, leitores de tela

#### Subagente: `ui`
**Missão:** Definir tokens de design, especificar componentes e garantir fidelidade visual.

**Skills:**
- `design-tokens` — Extrair tokens em CSS vars (web), Tailwind, NativeWind (Android), RN (iOS)
- `component-spec` — Especificar componentes com variantes e estados
- `responsive-guidelines` — Breakpoints (mobile <768px, tablet 768-1024px, desktop >1024px)
- `visual-consistency-checker` — Verificar fidelidade do código ao design_spec.md e high-fi

---

### 🏛️ Software Architect

**Fase:** 03 — Product Delivery (início)

**Missão:** Especialista em design de domínio, decisões arquiteturais e habilitação técnica. Referências: Evans (DDD), Fowler (Evolutionary Architecture), Newman (APIs). Opera após ler `tech_spec.md` e `product_briefing_spec.md`. Não escolhe tecnologia — toma decisões de domínio dentro das restrições do framework.

**Inputs:**
- `{REPO_DESTINO}/tech_spec.md`
- `{REPO_DESTINO}/product_briefing_spec.md`

**Outputs:**
```
{REPO_DESTINO}/03-product-delivery/architecture/
├── bounded-contexts.md
├── ubiquitous-language.md
├── context-map.md
├── aggregates.md
├── class-model.md
├── class-diagram.mermaid
├── api-contracts.md
├── db-schema.md
└── adrs/ADR-001.md, ADR-002.md, ...
```

#### Subagente: `domain-design`
**Missão:** Modelar o domínio usando DDD — bounded contexts, linguagem ubíqua, agregados e class model.

**Sequência obrigatória:** bounded-context-mapper → ubiquitous-language-builder → context-map-writer → aggregate-designer → class-model-designer → class-diagram-generator

**Skills:**
- `bounded-context-mapper` — Identificar e separar bounded contexts com responsabilidades claras
- `ubiquitous-language-builder` — Glossário de termos, definições e contexto de uso
- `context-map-writer` — Mapear relacionamentos: integração, anti-corruption layer, conformist
- `aggregate-designer` — Agregados com raízes, invariantes, eventos e fronteiras de consistência
- `class-model-designer` — Modelo completo com atributos, métodos e stereotypes DDD
- `class-diagram-generator` — Diagrama Mermaid a partir do class-model.md

#### Subagente: `system-design`
**Missão:** Definir arquitetura, contratos de API e modelagem de dados. Scaffolding do repositório.

**Skills:**
- `repo-scaffolder` — Criar estrutura completa do repositório monorepo no {REPO_DESTINO}
- `evolutionary-architecture` — Camadas arquiteturais, fitness functions e evolução sustentável
- `api-contract-designer` — Contratos tRPC com procedures, inputs Zod, outputs tipados, error codes
- `data-modeling` — Schema Drizzle baseado no class-model.md com tipos, constraints e índices

#### Subagente: `evaluation`
**Missão:** Avaliar tecnologias, riscos, build/buy e débito técnico com evidências.

**Skills:**
- `tech-radar` — Avaliar adoção/trial/assess/hold de tecnologias além do framework base
- `risk-assessment` — Identificar riscos (scalability, security, reliability, maintainability) + mitigação
- `build-vs-buy` — Analisar construir, comprar ou open source (custo, tempo, risco, manutenção)
- `technical-debt-tracker` — Catalogar e priorizar débito técnico com custo de carregamento

#### Subagente: `enablement`
**Missão:** Habilitar o time com padrões, revisões arquiteturais e análises contínuas.

**Skills:**
- `architecture-pairing` — Trabalhar junto ao time, revisando aderência aos ADRs e padrões
- `pattern-advisor` — Recomendar padrões de projeto adequados com justificativa e trade-offs
- `dependency-audit` — Mapear dependências externas, avaliar acoplamento e recomendar substituições
- `scalability-analysis` — Identificar gargalos e propor estratégias horizontais e verticais

---

### 🔧 Back End Developer

**Fase:** 03 — Product Delivery (após HITL #7)

**Missão:** Implementar API, services e persistência conforme `tech_spec.md` e contratos do Arquiteto. Opera com TDD — testes escritos junto com código. Routers delegam apenas para services (zero lógica de negócio), validação com Zod, persistência via Drizzle schema.

**Inputs:**
- `{REPO_DESTINO}/tech_spec.md`
- Contratos do Architect (schemas Zod, contratos tRPC, DB schema)

**Outputs:**
```
{REPO_DESTINO}/03-product-delivery/
├── api/
│   ├── routers/*.router.ts + *.router.md
│   ├── services/*.service.ts + *.service.test.ts
│   ├── db/schema.ts + migrations/
│   └── middleware/auth.ts + error-handler.ts
└── tests/unit/, integration/, api/
```

#### Subagente: `api`
**Missão:** Implementar routers tRPC e services de domínio. Zero lógica de negócio no router.

**Skills:**
- `api-builder` — Implementar routers e services tRPC com Drizzle e Supabase
- `contract-enforcer` — Verificar conformidade da implementação com contratos Zod/tRPC
- `auth-implementer` — Supabase Auth + middleware de contexto em procedures tRPC
- `error-handler` — Sistema padronizado com AppError e ErrorCode mapeados para TRPCError

#### Subagente: `persistence`
**Missão:** Camada de persistência: schema, migrations, repositories e queries otimizadas.

**Skills:**
- `schema-builder` — Schema Drizzle a partir do modelo de classes com tipos e constraints
- `migration-manager` — Gerar, revisar e aplicar migrations Drizzle com segurança
- `repository-implementer` — Repositories com Drizzle ORM seguindo padrão de acesso
- `query-optimizer` — Identificar e otimizar queries lentas com índices e explain plans

#### Subagente: `quality`
**Missão:** Garantir cobertura: unit + integration + API com rastreabilidade aos ACs. Testes junto com código.

**Skills:**
- `unit-test-writer` — Testes unitários Vitest cobrindo todos os casos do Mapa Three Amigos
- `integration-test-writer` — Testes que cruzam service + banco com Vitest e banco real de teste
- `api-test-writer` — Testes de procedures tRPC via createCaller com rastreabilidade
- `mock-builder` — Mocks tipados para Drizzle, Supabase Auth e dependências externas

#### Subagente: `living-docs`
**Missão:** Manter documentação viva do backend — API, schema, ADRs, comentários.

**Skills:**
- `api-documenter` — Documentar procedures tRPC com exemplos de input/output e erros
- `schema-documenter` — Documentar schemas Drizzle (tabelas, colunas, relacionamentos)
- `code-commenter` — JSDoc e comentários em lógica de domínio complexa
- `adr-logger` — Registrar ADRs sempre que uma decisão técnica for tomada no backend

---

### 🤖 AI Engineer

**Fase:** 03 — Product Delivery (paralelo ao Front End)

**Missão:** Projetar, implementar e proteger soluções de IA — chatbots, assistentes, agentes autônomos e pipelines RAG. Utiliza Anthropic Claude API como backend principal. Garante guardrails robustos contra prompt injection, vazamento de dados e perguntas fora do escopo.

**Princípios de Segurança Obrigatórios:**
1. Input Sanitization — sanitizar entrada antes do LLM
2. System Prompt Protection — nunca expor prompts ao usuário final
3. Output Validation — validar respostas antes de retornar
4. Scope Enforcement — rejeitar perguntas fora do domínio
5. PII Detection — bloquear vazamento de dados pessoais
6. Rate Limiting — limitar por usuário/IP
7. Logging & Audit — registrar interações (sem PII)
8. Fallback Graceful — respostas seguras em falha/timeout

#### Subagente: `chatbot-builder`
**Missão:** Construir chatbots conversacionais com Claude API. Persona, fluxos, contexto persistente e integração com backend. Nenhum chatbot vai a produção sem guardrails validados.

**Skills:**
- `conversation-designer` — Fluxos conversacionais com persona, tom, intenções e fallback
- `claude-api-integrator` — Integração Anthropic Messages API: streaming, tool use, rate limits
- `context-manager` — Histórico, janela de contexto e estratégias de resumo
- `prompt-engineer` — System prompts versionados com few-shot e chain-of-thought

#### Subagente: `agent-builder`
**Missão:** Criar agentes autônomos com tool use (function calling) e MCP. Raciocinam, planejam e agem. Least privilege — toda ação destrutiva requer confirmação humana.

**Skills:**
- `mcp-server-builder` — MCP servers que expõem ferramentas para agentes de IA
- `tool-use-designer` — Definições de tools para function calling com Claude API
- `agent-orchestrator` — Loop de raciocínio e decisão usando ReAct pattern
- `autonomous-workflow` — Workflows multi-step com checkpoints, rollback e recuperação

#### Subagente: `rag-pipeline`
**Missão:** Pipelines RAG que enriquecem LLM com conhecimento do domínio. Processamento → indexação → retrieval → resposta com citações. Documentos indexados uma vez, nunca reprocessados por query.

**Skills:**
- `document-processor` — Processar e dividir documentos em chunks para indexação
- `embedding-pipeline` — Gerar embeddings vetoriais e gerenciar vector stores
- `retrieval-optimizer` — Otimizar busca semântica: re-ranking, filtragem, hybrid search
- `grounded-response` — Respostas fundamentadas em documentos com citações e referências

#### Subagente: `ai-guardrails`
**Missão:** Camadas de segurança obrigatórias. Checados ANTES do input ao LLM e DEPOIS da resposta. Nenhuma solução de IA entra em produção sem todos os guardrails.

**Skills:**
- `prompt-injection-shield` — Detectar e bloquear tentativas de prompt injection
- `data-leakage-preventer` — Prevenir vazamento de PII, system prompts e dados internos
- `scope-enforcer` — Filtrar perguntas fora do domínio e redirecionar educadamente
- `safety-tester` — Testes adversariais executados antes de qualquer deploy

---

### 💻 Front End Developer

**Fase:** 03 — Product Delivery (após HITL #8, paralelo com AI Engineer)

**Missão:** Implementar UI web e mobile conforme `tech_spec.md` e `design_spec.md`. Fidelidade ao protótipo high-fi, Core Web Vitals positivos, WCAG 2.1 AA.

**Inputs:**
- `{REPO_DESTINO}/tech_spec.md`
- `{REPO_DESTINO}/design_spec.md`
- Contratos do Architect
- `{REPO_DESTINO}/02-product-discovery/prototype/high-fi.html`

**Outputs:**
- Código em `{REPO_DESTINO}/03-product-delivery/` (web + mobile)
- Testes unitários com cobertura ≥ 75%
- Testes E2E Playwright dos happy paths P0
- Documentação de componentes reutilizáveis

#### Subagente: `implementation`
**Missão:** UI com Next.js 15 + shadcn/ui + Tailwind, fiel ao high-fi e design_spec. Estado global, responsividade mobile-first.

**Skills:**
- `design-to-code` — Traduzir telas do high-fi para Next.js 15 com fidelidade visual
- `component-builder` — Componentes React com shadcn/ui e tokens do design_spec
- `state-management` — Estado global com Zustand e cache tRPC
- `responsive-implementer` — Layouts responsivos com Tailwind e breakpoints
- `mobile-identity` — Componentes Expo/React Native com NativeWind

#### Subagente: `quality`
**Missão:** Testes de componente, integração, E2E e acessibilidade. Co-location obrigatória (`component.tsx` → `component.test.tsx`).

**Skills:**
- `unit-test-writer` — Vitest + Testing Library cobrindo todos os ACs com rastreabilidade
- `integration-test-writer` — Integração front+back com mocks tRPC e asserções de behavior
- `e2e-script-writer` — Playwright para happy paths P0 com Page Object Model
- `accessibility-implementer` — WCAG 2.1 AA: roles, labels, contraste ≥ 4.5:1, teclado

#### Subagente: `performance`
**Missão:** Core Web Vitals positivos (LCP < 2.5s, CLS < 0.1, INP < 200ms) e bundle otimizado. Verificação pré-HITL #9.

**Skills:**
- `core-web-vitals-monitor` — Medir e otimizar LCP, CLS, INP com Vercel Speed Insights
- `rendering-strategist` — Server vs Client Component por rota, evitar waterfalls
- `bundle-optimizer` — Dynamic imports, code splitting, análise de bundle
- `caching-strategist` — Fetch cache, Route Segment Config, Upstash Redis

#### Subagente: `living-docs`
**Missão:** Documentação viva do frontend — componentes, ADRs, README.

**Skills:**
- `component-documenter` — Documentar componentes com exemplos, props e variantes
- `code-commenter` — JSDoc em hooks e lógica de UI complexa
- `readme-writer` — README do frontend com setup, estrutura e convenções
- `adr-logger` — Decisões técnicas locais do frontend

---

### 🧪 QA

**Fase:** Integrada desde Fase 02 (Shift-Left), com picos em 03

**Missão:** Garantir qualidade contínua do Discovery à Operação com rastreabilidade completa: AC → Caso de Teste → Implementação → Cobertura → Deploy. Cruza `product_briefing_spec.md` (funcional) e `tech_spec.md` (técnico).

**Inputs:**
- `{REPO_DESTINO}/product_briefing_spec.md`
- `{REPO_DESTINO}/tech_spec.md`
- Histórias com ACs
- Protótipo high-fi aprovado

**Outputs:**
- Matriz de rastreabilidade AC → CT com 100% de cobertura
- Testes automatizados (unit + E2E) com cobertura ≥ thresholds
- Relatório de qualidade para HITL #10
- Postmortems e relatórios de bugs com causa raiz

#### Subagente: `shift-left`
**Missão:** Qualidade antes do código — revisão de histórias, Three Amigos, mapa de casos de teste. Acionado **antes** de qualquer implementação na Fase 03.

**Skills:**
- `story-quality-reviewer` — Revisar ACs, RNs, campos; gerar matriz RN×AC×campos
- `risk-identifier` — Identificar riscos cedo (ACs ambíguos, validações faltando)
- `testability-advisor` — Design para testabilidade: DI, funções puras, evitar side effects
- `three-amigos-facilitator` — Sessão PO+Dev+QA construindo Mapa de Casos de Teste

#### Subagente: `exploratory`
**Missão:** Descobrir defeitos que automação não captura via exploração sistemática (sessões de 45-90 min).

**Skills:**
- `charter-designer` — Charters com missão, escopo, oráculos e critérios de parada
- `session-based-tester` — Sessões exploratórias time-boxed com debrief estruturado
- `edge-case-finder` — BVA, equivalence partitioning, state transitions
- `heuristic-tester` — SFDPOT (cobertura) e HICCUPPS (oráculos)

#### Subagente: `automation`
**Missão:** Automatizar testes com rastreabilidade aos ACs e ao Mapa de Casos de Teste.

**Skills:**
- `e2e-script-writer` — Playwright com Page Object Model, login via API, rastreáveis aos CTs
- `api-test-writer` — Testes de contrato tRPC: Zod, autorização, contratos, idempotência
- `performance-tester` — k6/autocannon validando SLOs de latência
- `test-data-builder` — Fixtures, factories e seeds tipados com Drizzle

#### Subagente: `quality-intelligence`
**Missão:** Medir, reportar e aprender. Acionado pré-HITL #10 e pós-incidente.

**Skills:**
- `quality-metrics` — Cobertura, rastreabilidade AC→CT, flakiness, bug escape rate
- `bug-reporter` — Bugs com contexto completo: reprodução, ambiente, severidade, impacto
- `postmortem-writer` — Postmortems de bugs críticos com causa raiz e ações preventivas
- `blameless-retrospective` — Retrospectivas focadas em sistemas, não culpa individual

---

### ⚙️ Operations Engineer

**Fase:** 04 — Product Operation (preparação inicia em 03)

**Missão:** Operar o projeto com CI/CD, deploy, observabilidade, A/B testing e gestão de mudança. Referências: Gene Kim (DevOps Handbook), Google SRE Book, Forsgren (Accelerate/DORA).

**Inputs:**
- `{REPO_DESTINO}/tech_spec.md`
- `{REPO_DESTINO}/design_spec.md` (dashboard)

**Outputs:**
- Pipeline GitHub Actions: lint → typecheck → testes → coverage → E2E → change-gate → deploy
- Variáveis por contexto (dev, preview, prod)
- Dashboard operacional (produto + SRE)
- SLOs/SLIs com error budgets
- GMUDs e registros de mudança
- Postmortems de incidentes

#### Subagente: `flow`
**Missão:** CI/CD, deploy automático, DORA metrics e redução de toil. Feature flags para rollouts controlados.

**Skills:**
- `pipeline-builder` — GitHub Actions com quality gates obrigatórios
- `deployment-strategist` — Deploy Vercel (web) e EAS (mobile), rollback automático, GMUD como gate
- `feature-flags-manager` — PostHog feature flags para A/B e rollouts graduais (5→20→50→100%)
- `dora-metrics-tracker` — Deployment Frequency, Lead Time, Change Failure Rate, MTTR; alvo elite
- `toil-reducer` — Automação Node.js, Dependabot, Vercel bot, pre-commit hooks

#### Subagente: `infrastructure`
**Missão:** Gerenciar infra com IaC, ambientes, capacidade e custos. Stack 100% managed.

**Skills:**
- `iac-writer` — Scripts de setup em Node.js (setup.mjs), cross-platform
- `environment-manager` — Variáveis por contexto no Vercel e GitHub Actions Secrets
- `capacity-planner` — Monitorar free tiers (Supabase 50K MAU, Upstash 10K cmd/dia, etc.)
- `finops-optimizer` — Controlar custos cloud e otimizar free tiers

#### Subagente: `reliability`
**Missão:** SLOs, monitoramento 24/7, resposta estruturada a incidentes, postmortems sistêmicos. Minimizar MTTR.

**Skills:**
- `slo-sla-designer` — SLOs realistas (99.5% API, <500ms p95), SLIs mensuráveis, error budgets
- `monitoring-setup` — Sentry (erros), New Relic (APM), PostHog (produto); alertas por SLO
- `incident-commander` — Resposta P0/P1/P2/P3: detecção, contenção, diagnóstico, resolução
- `blameless-postmortem-writer` — Postmortems com causa raiz sistêmica (5 Porquês) e ações preventivas

#### Subagente: `devsecops`
**Missão:** Integrar segurança ao pipeline — SAST, vulnerability scanning, secrets, compliance.

**Skills:**
- `security-pipeline-integrator` — Checks no CI: pnpm audit, Biome rules (noDangerouslySetInnerHtml, noExplicitAny)
- `secrets-manager` — .env tipado, Vercel Secrets, GitHub Secrets; nunca hardcode
- `vulnerability-scanner` — pnpm audit regular, Dependabot para CVEs
- `compliance-as-code` — Verificações: RLS Supabase, rate limiting Upstash, validação Zod

#### Subagente: `dashboard`
**Missão:** Dashboard operacional combinando métricas de produto (uso, outcomes) com técnicas (SRE, DORA). Opera em Fase 04 após primeiro deploy.

**Skills:**
- `dashboard-builder` — HTML standalone com Chart.js e identidade visual do design_spec.md, 4 seções
- `product-metrics-designer` — Eventos PostHog: DAU/MAU, retenção, adoção, funnels, KR mapping
- `sre-metrics-designer` — SLIs/SLOs (99.5%, <500ms p95), DORA (4 métricas), alertas

#### Subagente: `change-manager`
**Missão:** Governar toda mudança em produção via GMUD formal. **Zero deploy sem GMUD aprovada** — regra inviolável.

**Skills:**
- `gmud-writer` — Documento GMUD: identificação, descrição, impacto, testes, plano de rollback
- `risk-assessor` — Avaliação em 6 dimensões (complexidade, abrangência, reversibilidade, testes, histórico, janela) com score 1-30
- `change-approver` — Parecer: APROVADA / COM CONDIÇÕES / DEFERIDA / REJEITADA; bloqueia deploy sem aprovação

---

## 7. Resumo Estatístico

| Métrica | Valor |
|---------|-------|
| **Agentes** | 9 (+ 1 orquestrador) |
| **Subagentes** | 39 |
| **Skills** | 162+ |
| **Fases** | 4 sequenciais com retroalimentação |
| **HITLs** | 12 (13 contando #8.5) |
| **Inputs obrigatórios** | 4 (3 specs + repo destino) |
| **Arquivos CLAUDE.md** | ~50 (hierarquia raiz → agente → subagente) |

### Distribuição de Subagentes por Agente

| Agente | Subagentes | Skills (aprox) |
|--------|-----------|----------------|
| Product Manager | 4 | 16 |
| Product Owner | 3 | 10 |
| Product Designer | 3 | 16 |
| Software Architect | 4 | 18 |
| Back End Developer | 4 | 16 |
| AI Engineer | 4 | 16 |
| Front End Developer | 4 | 17 |
| QA | 4 | 16 |
| Operations | 6 | 22 |
| **Total** | **39** | **~162** |

### Estrutura de Arquivos

```
ecp-ai-multi-agent-squad/
├── CLAUDE.md                          # Regras globais + contrato de inputs
├── README.md
├── validate-inputs.mjs                # Pre-flight validator
│
├── agents/
│   ├── orchestrator/CLAUDE.md
│   ├── product-manager/
│   │   ├── CLAUDE.md
│   │   └── subagents/{market-research, product-vision, product-strategy, metrics}/
│   │       ├── CLAUDE.md
│   │       └── skills/*.md
│   ├── product-owner/...
│   ├── product-designer/...
│   ├── software-architect/...
│   ├── backend-developer/...
│   ├── ai-engineer/...
│   ├── frontend-developer/...
│   ├── qa/...
│   └── operations/...
│
├── shared/
│   ├── memory/context.json            # Estado da sessão
│   ├── schemas/
│   │   ├── agent-contract.md
│   │   ├── input-contracts.md
│   │   └── ost-schema.md
│   ├── identity/design_spec_template.md
│   └── templates/{fase-aprovacao-template.md, scaffold-app.mjs}
│
├── phases/{01-strategic-context, 02-product-discovery, 03-product-delivery, 04-product-operation}/
└── docs/squad-definition.md           # Este arquivo
```

---

**Fim do documento.**
