---
name: claude-api-integrator
description: Integrar a aplicação com a Anthropic Claude Messages API. Acionar quando precisar implementar chamadas à API Claude, configurar streaming de respostas, definir system prompts programaticamente, usar tool use / function calling, ou gerenciar tokens e rate limits. Cobre autenticação, modelos, parâmetros, tratamento de erros e boas práticas de uso da API.
---

# Claude API Integrator

## O que faz
Implementa a integração técnica com a Anthropic Claude API, cobrindo autenticação, chamadas à Messages API, streaming, tool use e gestão de erros.

## Padrão de Integração

### Setup Base
```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});
```

### Chamada Padrão com Streaming
```typescript
async function chat(userMessage: string, conversationHistory: Message[]) {
  const stream = await client.messages.stream({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 1024,
    system: getSystemPrompt(), // Nunca hardcoded — sempre função
    messages: [...conversationHistory, { role: 'user', content: userMessage }],
  });

  for await (const event of stream) {
    if (event.type === 'content_block_delta' && event.delta.type === 'text_delta') {
      yield event.delta.text;
    }
  }
}
```

### Tool Use
```typescript
const tools = [
  {
    name: 'get_balance',
    description: 'Consultar saldo da conta do usuário autenticado',
    input_schema: {
      type: 'object',
      properties: {
        account_id: { type: 'string', description: 'ID da conta' }
      },
      required: ['account_id']
    }
  }
];
```

## Regras de Segurança
- API key NUNCA no código — sempre variável de ambiente
- System prompt carregado de arquivo versionado, nunca inline
- Retry com exponential backoff em rate limit (429) e server error (5xx)
- Timeout de 30s para chamadas não-streaming, 60s para streaming
- Log de uso de tokens para controle de custos (sem logar conteúdo de mensagens)

## Seleção de Modelo
| Caso de Uso | Modelo Recomendado |
|-------------|-------------------|
| Chatbot conversacional | claude-sonnet-4-20250514 |
| Agente com raciocínio complexo | claude-sonnet-4-20250514 (extended thinking) |
| Tarefas simples / alto volume | claude-haiku-4-5-20251001 |
| Análise profunda / crítica | claude-opus-4-6 |

## Output
Módulo de integração com a Anthropic API pronto para uso, com streaming, error handling e logging.
