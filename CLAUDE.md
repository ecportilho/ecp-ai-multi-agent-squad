# 🚀 ECP AI Squad — Multi-Agent Product Squad

## Ambiente de Execução — Windows

> **Leia antes de qualquer coisa.** Este squad roda em Windows.

### Regras obrigatórias para todos os agentes

1. **NUNCA usar `find`, `grep`, `ls`, `kill`, `lsof`, `chmod` ou `cp -r` como comandos de shell**
   - Esses comandos falham no terminal do Windows mesmo com Git Bash configurado
   - Use as ferramentas nativas do Claude Code (Read, Write, Explore via UI) para navegar arquivos

2. **Para explorar a estrutura do projeto: use a ferramenta Read, não shell**
   - ❌ Errado: `Explore(find /path -type d)`
   - ✅ Correto: `Read("/caminho/do/arquivo")` ou listar via ferramenta de leitura

3. **Para criar pastas e arquivos: use a ferramenta Write do Claude Code**
   - ❌ Errado: `mkdir -p apps/web/src/components/{ui,layout}`
   - ✅ Correto: criar cada arquivo individualmente via ferramenta Write (o Claude Code cria as pastas intermediárias automaticamente)

4. **Caminhos usam barra normal `/`, nunca `\`**
   - O Cursor no Windows aceita `/` em todos os contextos

5. **Scripts `.sh` são executados via Git Bash ou Node.js — nunca diretamente no PowerShell**

### O que fazer se um agente tentar rodar um comando Unix
Se você ver um erro como `Sibling tool call errored` ou `find: command not found`, responda ao agente:

```
Ambiente: Windows com Cursor. Não use comandos shell Unix (find, grep, ls, kill).
Use as ferramentas Read/Write do Claude Code para acessar arquivos.
Recomece a tarefa usando apenas ferramentas nativas do Claude Code.
```

---

## ⚠️ CONTRATO DE ENTRADA OBRIGATÓRIO

> **O squad NÃO INICIA sem os 4 inputs abaixo validados.**

### 4 Inputs Obrigatórios

| # | Input | Tipo | Descrição |
|---|-------|------|-----------|
| 1 | `product_briefing_spec.md` | Arquivo | Escopo funcional, regras de negócio, público-alvo e restrições do produto |
| 2 | `tech_spec.md` | Arquivo | Especificação técnica: stack, arquitetura, padrões e regras invioláveis de código |
| 3 | `design_spec.md` | Arquivo | Identidade visual: paleta, tipografia, tokens, componentes e diretrizes de design |
| 4 | **Repositório destino** | Path (pasta) | Caminho absoluto ou relativo da pasta onde TODOS os outputs do squad serão gravados |

### Onde os inputs ficam
Os 3 arquivos markdown devem existir na **raiz** do repositório destino:
```
{REPO_DESTINO}/
├── product_briefing_spec.md
├── tech_spec.md
└── design_spec.md
```

### Validação antes de iniciar
O orquestrador executa **duas camadas** de validação:
1. **Script programático** — `validate-inputs.mjs` (Node.js, cross-platform) verifica existência dos arquivos e estrutura mínima
2. **Instrução comportamental** — o orquestrador lê os 3 arquivos e valida se possuem as seções esperadas (ver `shared/schemas/input-contracts.md`)

Se qualquer validação falhar, o squad **para e informa ao humano** qual input falta ou está incompleto.

### Referências dentro do squad
Todos os agentes referenciam os inputs via variável `{REPO_DESTINO}`:
- `{REPO_DESTINO}/product_briefing_spec.md` → alimenta Fases 01 e 02
- `{REPO_DESTINO}/tech_spec.md` → alimenta Fases 03 e 04
- `{REPO_DESTINO}/design_spec.md` → alimenta protótipos e toda implementação visual
- `{REPO_DESTINO}/` → destino de todos os outputs gerados

---

## Arquitetura do Squad
Squad de agentes de IA operado com Human in the Loop (HITL), organizado em 4 fases sequenciais com retroalimentação contínua via A/B testing em produção.

## Agentes do Squad
| Agente | Fase | Responsabilidade |
|--------|------|-----------------|
| 🧑‍💼 Product Manager | Estratégico | OKRs, OST, visão e métricas |
| 🎨 Product Designer | Discovery | Research, ideação e prototipação |
| 📋 Product Owner | Discovery | Priorização, épicos, features e histórias |
| 🏛️ Software Architect | Delivery | Domínio, sistema e decisões técnicas |
| 🔧 Back End Developer | Delivery | API + persistência + serviços |
| 💻 Front End Developer | Delivery | UI + integração + performance |
| 🧪 QA | Delivery | Qualidade e testes |
| ⚙️ Operations | Operação | Pipeline, infra, reliability e A/B |

## Fases e HITL
| Fase | Agentes | HITLs |
|------|---------|-------|
| 01 — Contexto Estratégico | PM | #1 |
| 02 — Product Discovery | PO → Designer → PO → PM+Designer+PO | #2 #3 #4 #5 #6 |
| 03 — Product Delivery | Arquiteto → Back End → Front End → QA | #7 #8 #9 #10 |
| 04 — Operação de Produto | Ops → PM (A/B) | #11 #12 |

## Regras Globais
- Nenhum agente inicia sem aprovação do HITL anterior
- Outputs registrados em `{REPO_DESTINO}/` por fase
- Estado da sessão mantido em `/shared/memory/context.json`
- Somente o orquestrador toma decisões de fase
- Skills são atômicas e idempotentes

## Identidade Visual
Definida no `{REPO_DESTINO}/design_spec.md`. O arquivo `shared/schemas/input-contracts.md` define a estrutura mínima esperada.

**Regra:** Nenhum agente inventa cores, fontes ou tokens. Tudo vem do `design_spec.md`.

## Stack Tecnológica
Definida no `{REPO_DESTINO}/tech_spec.md`. O arquivo `shared/schemas/input-contracts.md` define a estrutura mínima esperada.

**Regra:** Nenhum agente escolhe tecnologia sem consultar o `tech_spec.md`.

## Regras Invioláveis de Código
Definidas no `{REPO_DESTINO}/tech_spec.md`, seção de regras invioláveis. Todos os agentes de Delivery (Architect, Back End, Front End, QA) devem respeitar essas regras sem exceção.

## Output Final do Ciclo
Ao término da Fase 04 (após HITL #12), o site de documentação é gerado em:
`{REPO_DESTINO}/docs/` — contém todos os artefatos das 4 fases em formato navegável.
Detalhes: `agents/operations/subagents/flow/docs-generator.md`

## Convenções de Output
- Todos os outputs em JSON
- Erros: `{ "status": "error", "agent": "...", "phase": "...", "message": "..." }`
- HITL: `{ "hitl": N, "decision": "approved|rejected|approved_with_reservations", "feedback": "..." }`
