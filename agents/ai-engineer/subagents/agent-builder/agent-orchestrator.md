---
name: agent-orchestrator
description: Implementar o loop de raciocínio e decisão de agentes autônomos de IA. Acionar quando precisar criar o ciclo observe-think-act de um agente, implementar reasoning loops, definir condições de parada, gerenciar estado entre iterações, ou orquestrar múltiplas chamadas ao LLM com tools. Inclui ReAct pattern, planning e self-correction.
---

# Agent Orchestrator

## O que faz
Implementa o "cérebro" do agente — o loop que observa o estado, raciocina sobre o que fazer e executa ações via tools. É o coração de qualquer agente autônomo.

## Padrão ReAct (Reasoning + Acting)
```typescript
async function agentLoop(task: string, tools: Tool[], maxIterations: number = 10) {
  const messages: Message[] = [{ role: 'user', content: task }];
  
  for (let i = 0; i < maxIterations; i++) {
    const response = await client.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 4096,
      system: AGENT_SYSTEM_PROMPT,
      tools,
      messages,
    });

    // Verificar se o agente terminou
    if (response.stop_reason === 'end_turn') {
      return extractFinalAnswer(response);
    }

    // Processar tool calls
    if (response.stop_reason === 'tool_use') {
      const toolResults = await executeToolCalls(response.content);
      messages.push({ role: 'assistant', content: response.content });
      messages.push({ role: 'user', content: toolResults });
    }
  }

  throw new Error(`Agente excedeu ${maxIterations} iterações sem completar a tarefa`);
}
```

## Salvaguardas Obrigatórias
- **Max iterations** — Sempre definir limite (padrão: 10, máximo: 25)
- **Timeout global** — Agente tem tempo máximo total (padrão: 120s)
- **Cost cap** — Limite de tokens/custo por execução
- **Human-in-the-loop** — Ações destrutivas pausam e pedem confirmação
- **State checkpoint** — Salvar estado a cada iteração para recovery

## Output
Implementação do loop de agente com ReAct pattern, salvaguardas e logging.
