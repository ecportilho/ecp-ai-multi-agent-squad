---
name: scope-enforcer
description: Filtrar e redirecionar perguntas fora do escopo em chatbots e agentes de IA. Acionar quando precisar que o chatbot responda apenas sobre o domínio definido (ex: apenas assuntos bancários), rejeite educadamente perguntas off-topic, e não se envolva em conversas pessoais ou polêmicas. Inclui classificação de tópico e respostas de redirecionamento.
---

# Scope Enforcer

## O que faz
Garante que o chatbot responda apenas dentro do domínio definido. Um chatbot bancário não deve discutir receitas de bolo, opinar sobre política ou dar conselhos médicos.

## Implementação

### 1. Definir Escopo no System Prompt
```
ESCOPO PERMITIDO:
- Consultas sobre contas, saldos e extratos
- Informações sobre produtos bancários
- Suporte técnico do aplicativo
- Dúvidas sobre PIX e transferências

FORA DO ESCOPO (responder com redirecionamento):
- Opiniões políticas, religiosas ou pessoais
- Conselhos médicos, jurídicos ou financeiros pessoais
- Conversas pessoais ou emotivas
- Qualquer assunto não relacionado ao banco
```

### 2. Classificação de Tópico
```typescript
async function classifyTopic(input: string, allowedTopics: string[]): Promise<TopicResult> {
  const response = await client.messages.create({
    model: 'claude-haiku-4-5-20251001',
    max_tokens: 100,
    system: `Classifique se a mensagem está dentro do escopo permitido.
Tópicos permitidos: ${allowedTopics.join(', ')}
Responda em JSON: {"in_scope": true/false, "detected_topic": "...", "confidence": 0.0-1.0}`,
    messages: [{ role: 'user', content: input }]
  });
  return JSON.parse(response.content[0].text);
}
```

### 3. Respostas de Redirecionamento (Educadas)
```typescript
const REDIRECT_RESPONSES = {
  default: 'Essa pergunta está fora do que posso ajudar. Posso te ajudar com informações sobre sua conta, PIX ou produtos do banco.',
  personal: 'Agradeço a confiança, mas sou um assistente especializado em serviços bancários. Como posso te ajudar com sua conta?',
  controversial: 'Prefiro não opinar sobre esse assunto. Minha especialidade é te ajudar com serviços bancários. Precisa de algo?',
};
```

## Regras
- Redirecionamento é sempre educado — nunca dizer "não posso" seco
- Oferecer alternativa do escopo ao redirecionar
- Se o usuário insistir 3x no off-topic, sugerir canal humano
- Manter log de tópicos off-topic mais frequentes (feedback para produto)

## Output
Módulo de classificação de escopo com respostas de redirecionamento educadas.
