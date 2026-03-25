---
name: autonomous-workflow
description: Criar workflows multi-step para agentes de IA com checkpoints, rollback e recuperação de falhas. Acionar quando o agente precisa executar uma sequência de passos complexos (ex: processar pedido, analisar documento, gerar relatório), com capacidade de retomar de onde parou em caso de falha.
---

# Autonomous Workflow

## O que faz
Cria workflows estruturados para agentes executarem tarefas complexas com checkpoints. Diferente do loop simples do agent-orchestrator, workflows têm passos definidos, estados intermediários e capacidade de rollback.

## Padrão de Workflow
```typescript
interface WorkflowStep {
  id: string;
  name: string;
  execute: (context: WorkflowContext) => Promise<StepResult>;
  rollback?: (context: WorkflowContext) => Promise<void>;
  retries: number;
}

interface WorkflowContext {
  workflowId: string;
  currentStep: string;
  state: Record<string, unknown>;
  history: StepResult[];
}

async function executeWorkflow(steps: WorkflowStep[], context: WorkflowContext) {
  for (const step of steps) {
    context.currentStep = step.id;
    await saveCheckpoint(context); // Persistir estado

    let attempt = 0;
    while (attempt <= step.retries) {
      try {
        const result = await step.execute(context);
        context.state = { ...context.state, ...result.data };
        context.history.push(result);
        break;
      } catch (error) {
        attempt++;
        if (attempt > step.retries) {
          await rollbackFrom(step, steps, context);
          throw new WorkflowError(step.id, error);
        }
      }
    }
  }
}
```

## Princípios
- Todo passo que muda estado externo deve ter rollback definido
- Checkpoints salvos antes de cada passo — permite retomar de qualquer ponto
- Passos são idempotentes — executar 2x produz o mesmo resultado
- Timeout por passo (não apenas global)
- Notificação humana em falhas que não se recuperam automaticamente

## Output
Workflow engine com steps definidos, checkpoints, retry e rollback.
