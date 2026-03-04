# Skill — story-quality-reviewer

## Objetivo
Revisar histórias de usuário e critérios de aceite **antes do desenvolvimento iniciar** —
garantindo que toda história está pronta para ser testada e que os ACs são suficientes
para derivar casos de teste completos.

Esta skill é o portão de entrada para o Three Amigos e para o `test-case-designer`.
Uma história só entra em Sprint após passar por esta revisão.

---

## Dimensões de Avaliação

### 1. Qualidade da Narrativa

| Critério | Pergunta | Problema se NÃO |
|---------|---------|----------------|
| Persona específica | A história usa uma persona real (não "usuário")? | Dev não sabe para quem está construindo |
| "Para que" articulado | O benefício de negócio está claro? | Time não entende o valor entregue |
| Ação concreta | O "quero" descreve uma ação específica e mensurável? | Escopo ambíguo, estimativa impossível |
| Independência (INVEST-I) | A história pode ser desenvolvida sem outra em andamento? | Bloqueios de dependência no Sprint |
| Tamanho (INVEST-S) | Cabe em 1 Sprint sem quebrar? | Risco de arrastre |

### 2. Completude dos Critérios de Aceite

| Critério | Pergunta | Problema se NÃO |
|---------|---------|----------------|
| Happy path coberto | Existe ao menos 1 cenário de fluxo principal completo? | Base do teste não está definida |
| Fluxos alternativos | Cada alternativa documentada na história tem AC correspondente? | Comportamentos alternativos não testáveis |
| Cenários de erro | Cada exceção documentada tem AC com mensagem exata? | Dev inventa mensagens de erro |
| Validações de campo | Cada campo obrigatório tem AC de validação? | Regras de validação ficam implícitas |
| Regras de negócio | Cada RN da seção 4 tem ao menos 1 AC correspondente? | RN pode ser ignorada na implementação |
| Dados concretos | Os ACs usam valores específicos (não "algum valor")? | QA não consegue reproduzir o cenário |
| Mensagens exatas | Mensagens de erro estão com o texto literal? | Dev e QA divergem na mensagem |
| Estados de UI | Botões habilitados/desabilitados estão especificados? | Comportamento visual indefinido |
| Pós-condições | O estado do sistema após a ação está descrito? | Efeitos colaterais não verificados |

### 3. Testabilidade

| Critério | Pergunta | Problema se NÃO |
|---------|---------|----------------|
| Observabilidade | O resultado de cada AC é visível/verificável? | Não dá para escrever asserção |
| Determinismo | Dado o mesmo input, o resultado é sempre o mesmo? | Teste ficará flaky |
| Isolabilidade | O cenário pode ser testado sem depender de outros dados reais? | Testes frágeis e não reproduzíveis |
| Automatizabilidade | O AC pode ser coberto por teste automatizado? | Se não, documentar por que é manual |

### 4. Rastreabilidade

| Critério | Pergunta |
|---------|---------|
| IDs dos ACs | Cada AC tem ID único (AC-01, AC-02...)? |
| Referência ao protótipo | A história referencia a tela do protótipo? |
| Referência à doc funcional | A história referencia o arquivo de doc funcional? |
| Campos documentados | A tabela de campos da seção 6 está preenchida? |

---

## Processo de Revisão

### Passo 1 — Ler a história completa
Ler todos os campos da história, incluindo regras de negócio, campos e fluxos.

### Passo 2 — Verificar cada AC individualmente
Para cada AC, verificar se responde às perguntas:
- **Dado:** o contexto inicial está completo e sem ambiguidade?
- **Quando:** descreve uma única ação?
- **Então:** o resultado é observável e verificável?
- Os dados usados são concretos e específicos?

### Passo 3 — Verificar cobertura cruzada (ACs × RNs × Campos)

Construir a matriz de cobertura:

```
Matriz de Cobertura — STORY-XX

Regras de Negócio:
| RN | Descrição | AC que cobre |
|----|-----------|-------------|
| RN-01 | [regra] | AC-03, AC-04 |
| RN-02 | [regra] | ❌ SEM COBERTURA |  ← BLOQUEANTE

Campos de Entrada:
| Campo | Validação | AC que cobre |
|-------|-----------|-------------|
| valor | mínimo R$0,01 | AC-05 |
| chave | formato CPF | ❌ SEM COBERTURA |  ← BLOQUEANTE

Fluxos:
| Fluxo | Tipo | AC que cobre |
|-------|------|-------------|
| Principal | Happy path | AC-01 |
| Cancelamento | Alternativo | AC-02 |
| Saldo insuficiente | Exceção | AC-06 |
| Timeout API | Exceção sistêmica | ❌ SEM COBERTURA |  ← PENDENTE
```

### Passo 4 — Emitir parecer

```
APROVADA       → história pode entrar em Sprint
APROVADA COM RESSALVAS → pode entrar, mas as ressalvas devem ser resolvidas até refinement
BLOQUEADA      → deve voltar ao PO com os itens listados antes de entrar em Sprint
```

---

## Output Completo da Revisão

```markdown
# Revisão de Qualidade — STORY-[ID]

**Data:** [data]
**Revisado por:** QA Agent → Shift-Left → story-quality-reviewer
**Resultado:** ✅ APROVADA / ⚠️ APROVADA COM RESSALVAS / ❌ BLOQUEADA

---

## Avaliação por Dimensão

| Dimensão | Score | Observações |
|---------|-------|-------------|
| Qualidade da Narrativa | ✅/⚠️/❌ | [obs] |
| Completude dos ACs | ✅/⚠️/❌ | [obs] |
| Testabilidade | ✅/⚠️/❌ | [obs] |
| Rastreabilidade | ✅/⚠️/❌ | [obs] |

---

## Bloqueantes (impedem entrada no Sprint)
- [ ] [item bloqueante 1]
- [ ] [item bloqueante 2]

## Ressalvas (podem ser resolvidas durante o Sprint)
- [ ] [ressalva 1]

## Matriz de Cobertura

[tabela RN × AC e Campo × AC]

---

## Sugestões de ACs Faltantes

AC sugerido para RN-02 (Limite noturno):
```gherkin
Cenário: Bloqueio de Pix no horário noturno
  Dado que são 23h00
  E João tenta enviar R$ 1.500,00
  Quando João toca em "Continuar"
  Então o sistema exibe "Limite noturno de Pix: R$ 1.000,00"
  E o botão "Confirmar" fica desabilitado
```

---

## Rastreabilidade para os Próximos Passos

ACs prontos para derivar casos de teste:
- AC-01 → Caso de teste unitário (service) + E2E (Playwright)
- AC-02 → Caso de teste unitário (service)
- AC-05 → Casos de teste unitários parametrizados (boundary testing)
- AC-06 → Caso de teste unitário (mock de saldo insuficiente)

[Essa seção alimenta diretamente o test-case-designer]
```

---

## Output JSON

```json
{
  "story_id": "STORY-01",
  "reviewed_by": "qa-shift-left-story-quality-reviewer",
  "result": "approved | approved_with_caveats | blocked",
  "blockers": [],
  "caveats": [],
  "missing_acs_suggested": [],
  "coverage_matrix": {
    "business_rules": [
      { "id": "RN-01", "covered_by": ["AC-03", "AC-04"] },
      { "id": "RN-02", "covered_by": [] }
    ],
    "fields": [],
    "flows": []
  },
  "ac_to_test_mapping": [
    { "ac_id": "AC-01", "test_types": ["unit", "e2e"], "notes": "" }
  ]
}
```
