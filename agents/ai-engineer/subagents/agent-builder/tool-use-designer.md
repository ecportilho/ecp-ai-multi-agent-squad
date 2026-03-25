---
name: tool-use-designer
description: Projetar definições de tools para function calling com a Anthropic Claude API. Acionar quando precisar definir quais ferramentas um agente de IA pode usar, escrever schemas de tools, projetar fluxos de tool calling, ou otimizar como o LLM decide qual tool usar. Inclui naming, descriptions, input schemas e padrões de decisão.
---

# Tool Use Designer

## O que faz
Projeta as definições de tools que um agente de IA usa via function calling. Uma boa definição de tool é a diferença entre um agente que acerta a ferramenta certa e um que fica confuso.

## Princípios de Design

### 1. Naming Claro e Consistente
```
✅ get_account_balance    — verbo + substantivo, escopo claro
✅ list_transactions      — ação específica
❌ handle_account         — vago demais
❌ do_stuff               — sem semântica
```

### 2. Descriptions que Guiam a Decisão
A description é o que o LLM lê para decidir se usa a tool. Deve incluir:
- O que a tool faz
- Quando usar (e quando NÃO usar)
- O que retorna

```typescript
{
  name: 'get_account_balance',
  description: 'Retorna o saldo atual da conta bancária do usuário. Use quando o usuário perguntar sobre saldo, quanto tem na conta, ou quanto pode gastar. NÃO use para extrato ou transações — use list_transactions para isso.',
  input_schema: {
    type: 'object',
    properties: {
      account_id: {
        type: 'string',
        description: 'ID da conta (formato: ACC-XXXXX)'
      }
    },
    required: ['account_id']
  }
}
```

### 3. Granularidade Certa
- Uma tool = uma ação atômica
- Evitar tools "canivete suíço" que fazem muitas coisas
- Agrupar por domínio: `account_*`, `transaction_*`, `card_*`

## Padrão de Teste
Para cada tool definida, criar 3 cenários de teste:
1. **Happy path** — Input válido, resultado esperado
2. **Edge case** — Input no limite (vazio, muito grande, formato errado)
3. **Negative** — Input que NÃO deveria acionar esta tool

## Output
Conjunto de definições de tools com schemas validados e cenários de teste.
