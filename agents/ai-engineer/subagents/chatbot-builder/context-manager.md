---
name: context-manager
description: Gerenciar contexto de conversas de chatbot incluindo histórico de mensagens, janela de contexto, estratégias de resumo quando o contexto excede o limite, e persistência de estado entre sessões. Acionar quando implementar memória de chatbot, limitar tamanho de contexto, resumir conversas longas ou persistir histórico de chat.
---

# Context Manager

## O que faz
Implementa a gestão de contexto conversacional — o "cérebro de curto e longo prazo" do chatbot. Garante que o chatbot lembre do contexto relevante sem exceder limites de tokens.

## Estratégias de Contexto

### 1. Sliding Window (Padrão)
Manter as últimas N mensagens e descartar as mais antigas:
```typescript
function getContextWindow(messages: Message[], maxMessages: number = 20): Message[] {
  if (messages.length <= maxMessages) return messages;
  return messages.slice(-maxMessages);
}
```

### 2. Summarization (Conversas Longas)
Quando a conversa excede o limite, resumir o histórico anterior:
```typescript
async function summarizeHistory(messages: Message[]): Promise<string> {
  const summary = await client.messages.create({
    model: 'claude-haiku-4-5-20251001',
    max_tokens: 300,
    system: 'Resuma a conversa a seguir em 2-3 parágrafos, preservando: decisões tomadas, informações do usuário e contexto importante.',
    messages: [{ role: 'user', content: formatMessages(messages) }]
  });
  return summary.content[0].text;
}
```

### 3. Persistência entre Sessões
```typescript
interface ConversationState {
  id: string;
  userId: string;
  messages: Message[];
  summary: string | null;
  metadata: Record<string, unknown>;
  createdAt: Date;
  updatedAt: Date;
}
```

## Regras
- Nunca enviar mais de 80% do context window do modelo em mensagens
- Sempre preservar o system prompt + última mensagem do usuário (prioridade máxima)
- Resumos são gerados por modelo menor (Haiku) para economia
- Histórico persistido não inclui system prompt (segurança)
- Metadata do usuário (nome, preferências) é mantida fora do array de messages

## Output
Módulo de gerenciamento de contexto com sliding window, summarization e persistência.
