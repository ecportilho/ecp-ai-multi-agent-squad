# Skill: migration-manager

## Objetivo
Gerenciar migrações Drizzle de forma segura com rollback definido.

## Fluxo de Migration
```bash
# 1. Alterar o schema em packages/api/src/db/schema.ts
# 2. Gerar a migration
pnpm db:generate

# 3. Revisar o SQL gerado em src/db/migrations/
# 4. Aplicar em dev
pnpm db:migrate

# 5. Em produção — aplicar via CI/CD (nunca db:push em produção)
pnpm db:migrate
```

## Regras
- NUNCA `db:push` em produção — apenas em dev
- SEMPRE revisar o SQL gerado antes de aplicar
- SEMPRE testar rollback antes de deploy em produção
- Migrações são irreversíveis por padrão — planejar com cuidado
- Para renomear colunas: criar nova coluna → migrar dados → remover antiga (em 3 deploys)

## Checklist de Migration Segura
- [ ] Migration é aditiva? (add column, add table) → baixo risco
- [ ] Migration remove algo? → revisar com o time primeiro
- [ ] Coluna NOT NULL sendo adicionada? → definir DEFAULT ou fazer em 2 passos
- [ ] Índice em tabela grande? → usar `CONCURRENTLY` no SQL diretamente
