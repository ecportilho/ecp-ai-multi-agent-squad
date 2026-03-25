---
name: code-commenter
description: >
  Adicionar JSDoc e comentários em lógica de domínio complexa do backend.
  Use em services com regras de negócio não triviais, algoritmos financeiros, ou lógica de domínio crítica.
---

# Skill: code-commenter

## Objetivo
Adicionar JSDoc e comentários em lógica de negócio complexa no momento da escrita —
tornando o raciocínio explícito para quem vai manter o código depois.

## Quando Comentar

**Comentar SEMPRE:**
- Regras de negócio não óbvias (limites, cálculos, condições complexas)
- Algoritmos financeiros (especialmente operações com centavos)
- Condições de autorização e segurança
- Workarounds de APIs externas com referência ao issue/doc

**NÃO comentar:**
- O que o código obviamente faz (`// incrementa i`)
- Código auto-explicativo com naming bom
- `TODO` sem autor e sem prazo — criar issue em vez disso

## Padrões JSDoc

### Service Method
```typescript
/**
 * Processa transferência Pix verificando limite diário e noturno antes de debitar.
 *
 * Regras de negócio aplicadas:
 * - Limite diário: R$5.000,00 (500000 centavos) por usuário — RN-03
 * - Limite noturno (22h–6h Brasília): R$1.000,00 — RN-04
 * - Transferências idempotentes por idempotencyKey — garante at-most-once
 *
 * @param userId - ID do usuário remetente (UUID v4)
 * @param input - Dados da transferência validados por Zod
 * @returns Transação criada com status COMPLETED ou PENDING
 * @throws {AppError} FORBIDDEN - saldo insuficiente
 * @throws {AppError} BAD_REQUEST - limite diário ou noturno excedido
 * @throws {AppError} SERVICE_UNAVAILABLE - timeout na validação da chave Pix
 */
async sendTransfer(userId: string, input: SendTransferInput): Promise<Transaction>
```

### Lógica de Cálculo
```typescript
// ATENÇÃO: valores monetários SEMPRE em centavos (integer)
// nunca usar float — 0.1 + 0.2 !== 0.3 em IEEE 754
// referência: ADR-010
const totalCents = items.reduce((sum, item) => sum + item.amountCents, 0);
```

### Condição de Segurança
```typescript
// Verificar que o recurso pertence ao usuário antes de retornar
// Não usar apenas .findFirst({ where: eq(id, resourceId) })
// pois expõe IDs de outros usuários via timing attack
if (resource.userId !== ctx.user.id) {
  throw new AppError(ErrorCode.NOT_FOUND, "Resource not found");
  // NOT_FOUND intencional: não revelar que o recurso existe
}
```

## Regra Principal
Comentário explica o **porquê**, não o **o quê**.
Se o código precisa de comentário para explicar o que faz, considerar refatoração primeiro.
