---
name: api-documenter
description: >
  Documentar procedures tRPC com exemplos de input/output e códigos de erro.
  Use junto com a implementação de cada router — documentação deve ser escrita no mesmo momento do código.
---

# Skill: api-documenter

## Objetivo
Documentar procedures tRPC com exemplos de input/output, erros possíveis e contratos
de comportamento — escrita junto com o código, nunca como etapa posterior.

## Formato: README por Router

Criar `packages/api/src/routers/[nome].router.md` junto com o `.ts`:

```markdown
# Router: [nome]

## Procedures

### `[nome].getById`
Busca [recurso] por ID do usuário autenticado.

**Tipo:** Query (Protected)  
**Input:**
```typescript
{ id: string } // UUID v4
```
**Output:**
```typescript
{
  id: string;
  userId: string;
  amount: number; // centavos
  status: "PENDING" | "COMPLETED" | "FAILED";
  createdAt: Date;
}
```
**Erros:**
| Código | Quando |
|--------|--------|
| `NOT_FOUND` | ID não existe ou não pertence ao usuário autenticado |
| `UNAUTHORIZED` | Sessão expirada ou token inválido |

---

### `[nome].create`
Cria novo [recurso] para o usuário autenticado.

**Tipo:** Mutation (Protected)  
**Input:** `CreateSomethingInput` (de `@{scope}/shared/schemas`)  
**Output:** O [recurso] criado com ID gerado  
**Erros:**
| Código | Quando |
|--------|--------|
| `BAD_REQUEST` | Input inválido (Zod) |
| `FORBIDDEN` | Usuário sem permissão para esta operação |
| `DUPLICATE` | Já existe um [recurso] com este [campo único] |
```

## Regra Principal
Documentação é escrita **junto** com o código, no mesmo commit.
Router sem `.md` correspondente não está documentado — tratar como dívida técnica.
