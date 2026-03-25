# Persistence Subagent — Back End Developer

## Quando Acionar
Acionado pelo Back End Developer Agent na **Fase 03**, após `api-builder` estabelecer os services.
Opera com o schema Drizzle definido pelo Software Architect.

## Responsabilidade
Implementar camada de persistência: schema, migrations, repositories e queries otimizadas.

## Skills
| Skill | Arquivo | Quando Usar |
|-------|---------|-------------|
| `schema-builder` | `schema-builder.md` | Construir schema Drizzle a partir do class-model.md |
| `migration-manager` | `migration-manager.md` | Gerar e aplicar migrations com segurança |
| `repository-implementer` | `repository-implementer.md` | Criar camada de acesso a dados para cada agregado |
| `query-optimizer` | `query-optimizer.md` | Otimizar queries lentas com índices e explain |

## Regras
- Schema nunca alterado manualmente — sempre via migration
- Valores monetários em integer (centavos) — nunca float
- UUIDs v4 como primary keys — nunca auto-increment
- Cursor-based pagination em todas as listagens
