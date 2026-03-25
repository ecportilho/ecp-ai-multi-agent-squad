---
name: user-story-writer
description: >
  Redigir histórias de usuário completas e autossuficientes com narrativa, regras de negócio, campos, fluxos, DoR e DoD. Use ao estruturar o backlog na Fase 02 — um dev e um QA devem conseguir implementar e testar sem perguntas adicionais.
---

# Skill: user-story-writer

## Objetivo
Redigir histórias de usuário completas, ricas e autossuficientes — um desenvolvedor e um QA conseguem implementar e testar sem fazer nenhuma pergunta adicional.

## Fonte de Entrada
- Fluxos do protótipo high-fi aprovado no HITL #5
- Mapa de fluxo gerado pelo low-fi-prototyper
- Oportunidades e hipóteses validadas na Fase 02
- Documentação funcional da funcionalidade (gerada pela skill `functional-documentation-writer`)

---

## Estrutura Completa de uma História

Cada história deve conter **todos** os campos abaixo. Nenhum campo é opcional.

```markdown
# [STORY-ID] — [Título conciso e orientado a ação]

## Narrativa
**Como** [persona específica — não "usuário genérico"]
**Quero** [ação concreta e específica]
**Para que** [benefício de negócio ou de experiência claramente articulado]

## Contexto
[2–4 frases explicando a situação em que o usuário está ao executar essa ação.
Descrever o estado anterior, o que motivou a ação e o que muda depois.
Referenciar o fluxo no protótipo quando aplicável.]

## Persona
- **Nome:** [ex: João — Pessoa Física / MEI]
- **Perfil:** [1–2 linhas do perfil relevante para essa história]
- **Objetivo nesse momento:** [o que ele quer resolver agora]

## Pré-condições
- [ ] [Estado que deve ser verdadeiro ANTES do usuário iniciar essa ação]
- [ ] [ex: Usuário autenticado com sessão ativa]
- [ ] [ex: Conta com saldo suficiente]

## Regras de Negócio
Liste todas as regras que governam essa história. Seja explícito — sem regras implícitas.

| # | Regra | Detalhe |
|---|-------|---------|
| RN-01 | [Nome curto da regra] | [Descrição completa e inequívoca] |
| RN-02 | ... | ... |

## Campos e Dados

Liste todos os campos envolvidos nessa história — de entrada, de exibição e de saída.

| Campo | Tipo | Obrigatório | Validação | Máscara/Formato | Observação |
|-------|------|------------|-----------|-----------------|------------|
| [nome do campo] | texto/número/data/enum | sim/não | [regra de validação] | [formato visual] | [contexto adicional] |

## Fluxo Principal (Happy Path)
Passos numerados do ponto de vista do usuário:

1. [Passo 1 — ação do usuário]
2. [Passo 2 — o que o sistema faz / exibe]
3. [Passo 3 — próxima ação do usuário]
4. [Passo N — resultado final]

## Fluxos Alternativos
Descrever desvios do caminho principal que ainda chegam ao sucesso:

**Alternativo A — [Nome]:**
- A1. [Quando: condição que dispara esse fluxo]
- A2. [O que o usuário vê/faz diferente]
- A3. [Como retorna ao fluxo principal ou chega ao resultado]

## Fluxos de Exceção / Erro
Descrever o que acontece quando algo falha:

**Exceção E1 — [Nome do erro]:**
- Condição: [quando ocorre]
- Mensagem exibida: "[texto exato da mensagem de erro]"
- Ação disponível: [o que o usuário pode fazer para se recuperar]

## Critérios de Aceite
Ver skill `acceptance-criteria-writer` para os cenários Gherkin completos.
Mínimo: 1 happy path + todos os fluxos alternativos + todos os fluxos de exceção.

## Referências Visuais
- Protótipo: `{REPO_DESTINO}/02-product-discovery/prototype/high-fi-[fluxo].html`
- Tela(s): [IDs das telas no mapa de fluxo — ex: screen-pix-enviar, screen-pix-confirmar]
- Componentes: [ex: Bottom Sheet de confirmação, Campo de valor com máscara BRL]

## Referência à Documentação Funcional
- Funcionalidade: [ex: Pix — Enviar]
- Arquivo: `{REPO_DESTINO}/docs/funcional/[funcionalidade].md`

## Notas de UX / Design
[Detalhes visuais ou de interação críticos para implementação correta.
Ex: "O campo de valor deve formatar em tempo real enquanto o usuário digita.
O botão Confirmar permanece desabilitado até a chave ser validada."]

## Notas Técnicas
[Informações relevantes para o dev — sem prescrever a solução.
Ex: "A validação da chave Pix requer chamada à API do Banco Central.
Consultar o arquiteto antes de implementar — há cache previsto."]

## Definition of Ready (DoR)
A história só entra em Sprint quando:
- [ ] Narrativa clara e aprovada pelo PO
- [ ] Todos os campos mapeados com validações
- [ ] Todas as regras de negócio listadas e validadas com o negócio
- [ ] Protótipo de referência disponível e aprovado
- [ ] Critérios de aceite escritos e revisados com QA
- [ ] Dependências técnicas identificadas
- [ ] Estimada em story points pelo time

## Definition of Done (DoD)
A história só é concluída quando:
- [ ] Código implementado e revisado (PR aprovado)
- [ ] Todos os critérios de aceite passando
- [ ] Testes unitários escritos (cobertura >= 80% no service layer)
- [ ] Teste de integração ou E2E cobrindo o happy path
- [ ] Sem erros de TypeScript (`pnpm typecheck`)
- [ ] Sem erros de lint (`pnpm lint`)
- [ ] Acessibilidade verificada (WCAG 2.1 AA)
- [ ] Revisado pelo QA em ambiente de staging
- [ ] Documentação funcional atualizada se necessário

## Estimativa
- **Story Points:** [1 / 2 / 3 / 5 / 8 / 13] (Fibonacci)
- **Critério:** [justificativa breve da estimativa]
- **Risco:** baixo / médio / alto
- **Dependências:** [outras histórias ou componentes que devem estar prontos antes]
```

---

## Critérios INVEST (verificar antes de finalizar)

| Critério | Pergunta | OK? |
|---------|---------|-----|
| **I**ndependente | Esta história pode ser desenvolvida sem depender de outra em andamento? | |
| **N**egociável | O escopo pode ser ajustado em conversa com o time sem perder o valor central? | |
| **V**aliosa | Entrega valor real ao usuário ou ao negócio por si só? | |
| **E**stimável | O time consegue estimar sem fazer perguntas? | |
| **S**mall | Cabe em 1 Sprint sozinha? (Se não → story-splitter) | |
| **T**estável | Os critérios de aceite permitem testar objetivamente? | |

---

## Anti-patterns — Nunca Fazer

| Anti-pattern | Problema | Correção |
|-------------|---------|---------|
| "Como usuário, quero poder fazer X" | "usuário" é genérico demais | Usar persona específica com contexto |
| Narrativa sem "para que" | Perde o valor de negócio | Sempre incluir o benefício articulado |
| Campos sem validação | Dev inventa regras | Especificar todas as validações |
| Regras implícitas | Dev descobre na revisão | Tornar toda regra explícita |
| História com múltiplos objetivos | Viola o S do INVEST | Separar com story-splitter |
| AC apenas no happy path | QA não sabe o que testar nos erros | Incluir todos os cenários de exceção |
| "O sistema deve..." no lugar do usuário | Linguagem técnica, não de negócio | Reescrever do ponto de vista do usuário |
| Notas técnicas prescrevendo solução | Remove autonomia do time de dev | Descrever o QUÊ, não o COMO |

---

## Output JSON
```json
{
  "story_id": "STORY-01",
  "feature_id": "FEAT-01",
  "epic_id": "EPIC-01",
  "title": "",
  "persona": "",
  "narrative": {
    "as_a": "",
    "i_want": "",
    "so_that": ""
  },
  "context": "",
  "preconditions": [],
  "business_rules": [
    { "id": "RN-01", "name": "", "description": "" }
  ],
  "fields": [
    {
      "name": "",
      "type": "",
      "required": true,
      "validation": "",
      "format": "",
      "notes": ""
    }
  ],
  "happy_path": [],
  "alternative_flows": [],
  "exception_flows": [],
  "ux_notes": "",
  "technical_notes": "",
  "prototype_reference": "",
  "functional_doc_reference": "",
  "story_points": 0,
  "risk": "low | medium | high",
  "dependencies": [],
  "invest_ok": true
}
```
