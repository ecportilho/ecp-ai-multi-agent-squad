# API Subagent — Back End Developer

## Quando Acionar
Acionado pelo Back End Developer Agent na **Fase 03 (Product Delivery)**, após HITL #7.
Opera após o Software Architect definir contratos tRPC e schemas Zod.

## Responsabilidade
Implementar routers tRPC e services de domínio seguindo os contratos do Arquiteto.

## Skills
| Skill | Arquivo | Quando Usar |
|-------|---------|-------------|
| `api-builder` | `api-builder.md` | Criar ou expandir routers tRPC e services |
| `contract-enforcer` | `contract-enforcer.md` | Verificar conformidade com contratos antes do HITL #8 |
| `auth-implementer` | `auth-implementer.md` | Implementar autenticação Supabase e proteção de rotas |
| `error-handler` | `error-handler.md` | Padronizar tratamento de erros com AppError/ErrorCode |

## Regras
- Routers **delegam apenas** — zero lógica de negócio
- Toda lógica de negócio em services
- Input de toda procedure validado com Zod
- `AppError` com `ErrorCode` em vez de `throw new Error()`
