# Skill: error-handler

## Objetivo
Implementar sistema padronizado de erros com AppError e ErrorCode.

## Implementação
```typescript
// packages/shared/src/errors/error-codes.ts
export enum ErrorCode {
  INTERNAL_ERROR = "INTERNAL_ERROR",
  INVALID_INPUT = "INVALID_INPUT",
  NOT_FOUND = "NOT_FOUND",
  UNAUTHORIZED = "UNAUTHORIZED",
  FORBIDDEN = "FORBIDDEN",
  DUPLICATE = "DUPLICATE",
  RATE_LIMITED = "RATE_LIMITED",
  // Adicionar códigos específicos do domínio abaixo
}

// packages/shared/src/errors/app-error.ts
export class AppError extends Error {
  constructor(
    public readonly code: ErrorCode | string,
    message: string,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "AppError";
  }
}
```

## Uso nos Services
```typescript
// ✅ CORRETO
throw new AppError(ErrorCode.NOT_FOUND, "Board não encontrado");
throw new AppError(ErrorCode.INVALID_INPUT, "Valor inválido", { field: "amount" });

// ❌ ERRADO
throw new Error("Board não encontrado");
```

## Mapeamento AppError → TRPCError
O `errorMappingMiddleware` em `packages/api/src/trpc.ts` faz o mapeamento automaticamente.
NUNCA fazer esse mapeamento manualmente nos services.

## Regras
- NUNCA `try/catch` vazio — sempre re-throw ou log + re-throw
- NUNCA engolir erros silenciosamente
- SEMPRE logar com contexto: resourceId, userId, operação
