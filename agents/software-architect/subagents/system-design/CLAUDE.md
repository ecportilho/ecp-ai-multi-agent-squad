# System Design Agent

## Skills

| Skill | Arquivo | Quando |
|-------|---------|--------|
| `repo-scaffolder` | `repo-scaffolder.md` | **Primeiro de tudo** — cria o repositório no GitHub |
| `evolutionary-architecture` | `evolutionary-architecture.md` | Decisões de arquitetura e ADRs |
| `api-contract-designer` | `api-contract-designer.md` | Contratos tRPC antes do backend implementar |
| `data-modeling` | `data-modeling.md` | Schema Drizzle + migrations |
| `adr-writer` | `adr-writer.md` | Registrar decisões arquiteturais |

## Sequência Obrigatória na Fase 03

```
1. repo-scaffolder          → cria o repositório no GitHub (uma única vez)
2. evolutionary-architecture → define as camadas e decisões
3. api-contract-designer    → contratos das procedures antes do backend
4. data-modeling            → schema Drizzle baseado no class-model.md
```

## Regra Crítica
O `repo-scaffolder` é executado **antes de qualquer outro agente escrever código**.
O Backend Dev, Frontend Dev e QA só começam a trabalhar após o repositório existir no GitHub.
