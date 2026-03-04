# Skill — three-amigos-facilitator

## Objetivo
Facilitar a sessão de alinhamento entre PO (Product Owner), Dev (Backend + Frontend) e
QA **antes** de qualquer implementação. O principal entregável da sessão é o
**Mapa de Casos de Teste** — a lista definitiva do que deve ser testado e como.

## Quando Executar
Uma vez por história, após a `story-quality-reviewer` aprovar a história.
Antes de qualquer linha de código ser escrita.

---

## Agenda da Sessão (45 min)

### Parte 1 — PO apresenta a história (10 min)
- Leitura da narrativa e contexto de negócio
- Explicação de cada regra de negócio com exemplos reais
- Walkthrough dos campos, validações e mensagens de erro
- Esclarecimento de ambiguidades antes de continuar

### Parte 2 — Dev identifica riscos de implementação (10 min)
Perguntas que o Dev deve trazer:
- Há dependência de serviço externo que pode falhar (API Banco Central, Upstash)?
- A lógica envolve concorrência ou race conditions?
- Há migração de banco de dados? É reversível?
- Quais partes do código existente serão tocadas?
- Qual o risco de regressão nos fluxos já funcionando?

### Parte 3 — QA mapeia cenários de teste (15 min)
QA conduz derivação sistemática de casos de teste a partir dos ACs:

**Derivação por tipo:**
```
Para cada AC da história:
  1. AC de happy path → Caso de teste unitário (service) + E2E (Playwright)
  2. AC de fluxo alternativo → Caso de teste unitário
  3. AC de validação de campo → Casos parametrizados (boundary: abaixo, no limite, acima)
  4. AC de regra de negócio → Caso de teste unitário com mock da condição
  5. AC de erro sistêmico → Caso de teste unitário com mock de falha de API/banco
  6. AC de erro de usuário → Caso de teste unitário + E2E (mensagem visível)
```

**Checklist de cenários que o QA deve levantar:**
- O que acontece se o usuário submeter o form duas vezes (duplo clique)?
- O que acontece se a sessão expirar durante o fluxo?
- O que acontece se a conexão cair no meio de uma transação?
- O que acontece com valores nos limites exatos (mínimo, máximo)?
- O que acontece com caracteres especiais ou injeção em campos de texto?
- O que acontece com fuso horário (ex: limite noturno Pix às 22h00:00 exato)?
- O que acontece se o serviço externo demorar mais que o timeout?

### Parte 4 — Acordar DoD e casos fora de escopo (10 min)
- Confirmar Definition of Done específica para esta história
- Listar explicitamente o que está FORA do escopo desta história
- Confirmar quais casos serão automatizados vs. manuais
- Definir quem escreve qual teste (Dev escreve unit, QA revisa e complementa E2E)

---

## Mapa de Casos de Teste (Output Principal)

Este documento é criado durante a sessão e entregue ao Dev e ao QA antes de implementar:

```markdown
# Mapa de Casos de Teste — STORY-[ID]
# [Título da História]

**Sessão realizada em:** [data]
**Participantes:** PO Agent, Backend Dev Agent, Frontend Dev Agent, QA Agent

---

## Casos de Teste por AC

### AC-01 — [Título do AC] (Happy Path)
| # | Caso de Teste | Tipo | Responsável | Ferramenta | Prioridade |
|---|--------------|------|------------|-----------|-----------|
| CT-001 | Pix enviado com sucesso via chave CPF | Unit (service) | Dev | Vitest | P0 |
| CT-002 | Fluxo completo de envio de Pix no browser | E2E | QA | Playwright | P0 |

**Dados de entrada para CT-001:**
```typescript
input: { key: "12345678900", keyType: "CPF", amountCents: 15000, description: "Almoço" }
mock:  pixKeyService.validate → { name: "Maria Silva", taxId: "123.456.789-00" }
mock:  accountService.debit → { success: true, newBalanceCents: 185000 }
expected: { status: "COMPLETED", endToEndId: expect.any(String) }
```

### AC-05 — Validação do campo valor (Boundary Testing)
| # | Caso de Teste | Input | Expected | Tipo | Ferramenta |
|---|--------------|-------|---------|------|-----------|
| CT-010 | Valor zero rejeitado | amountCents: 0 | BAD_REQUEST "Valor mínimo R$0,01" | Unit | Vitest |
| CT-011 | Valor mínimo aceito | amountCents: 1 | COMPLETED | Unit | Vitest |
| CT-012 | Valor no limite diário aceito | amountCents: 500000 | COMPLETED | Unit | Vitest |
| CT-013 | Valor acima do limite diário rejeitado | amountCents: 500001 | BAD_REQUEST "Limite diário excedido" | Unit | Vitest |
| CT-014 | Valor negativo rejeitado | amountCents: -100 | BAD_REQUEST | Unit | Vitest |

### AC-06 — Saldo insuficiente (Exceção)
| # | Caso de Teste | Tipo | Ferramenta |
|---|--------------|------|-----------|
| CT-020 | Retorna FORBIDDEN quando saldo < valor solicitado | Unit (service) | Vitest |
| CT-021 | Mensagem "Saldo insuficiente" exibida na UI | E2E | Playwright |

### AC-08 — Timeout na validação da chave (Erro Sistêmico)
| # | Caso de Teste | Tipo | Ferramenta |
|---|--------------|------|-----------|
| CT-025 | Service retorna SERVICE_UNAVAILABLE quando API BC não responde em 10s | Unit | Vitest |
| CT-026 | Nenhuma cobrança é feita se timeout ocorrer antes da confirmação | Unit | Vitest |

---

## Casos Fora de Escopo desta História
- Pix programado para data futura (STORY-08)
- Pix para contas internacionais (fora do produto v1)
- Estorno de Pix (STORY-12)

---

## Casos Manuais (não automatizáveis)
| Caso | Motivo | Responsável |
|------|--------|------------|
| Validação visual do comprovante em PDF | Requer inspeção visual | QA manual no staging |
| Acessibilidade com leitor de tela | Requer testes com NVDA/VoiceOver | QA manual |

---

## Definition of Done — STORY-[ID]
- [ ] Todos os CTs unitários (CT-001 a CT-026) implementados e passando
- [ ] Todos os CTs E2E implementados e passando no headless
- [ ] Cobertura do service `PixService` >= 90%
- [ ] CTs manuais executados no staging e aprovados pelo QA
- [ ] PR aprovado com CI completo passando
- [ ] Documentação funcional atualizada se alguma RN mudou
```

---

## Output JSON

```json
{
  "story_id": "STORY-01",
  "session_date": "",
  "participants": ["po-agent", "backend-dev-agent", "frontend-dev-agent", "qa-agent"],
  "test_cases": [
    {
      "id": "CT-001",
      "ac_id": "AC-01",
      "title": "",
      "type": "unit | integration | e2e | manual",
      "tool": "vitest | playwright | manual",
      "responsible": "dev | qa",
      "priority": "P0 | P1 | P2",
      "test_data": {},
      "mocks_required": [],
      "expected_result": ""
    }
  ],
  "out_of_scope": [],
  "manual_cases": [],
  "risks_identified": [],
  "definition_of_done": []
}
```
