---
name: query-optimizer
description: >
  Identificar e otimizar queries lentas no Drizzle/Supabase com índices e explain plans. Use quando queries ultrapassarem thresholds de latência ou ao revisar performance do banco.
---

# Skill: query-optimizer

## Objetivo
Identificar e otimizar queries Drizzle lentas ou ineficientes.

## Checklist de Otimização
- [ ] Índices criados para todas as colunas em WHERE, JOIN, ORDER BY
- [ ] N+1 queries eliminados (usar joins ou batch queries)
- [ ] Cursor-based pagination em listas longas
- [ ] `select()` com colunas específicas (não `select *` em tabelas grandes)
- [ ] Conexão ao banco via Supabase pooler (pgbouncer) em produção
- [ ] `DATABASE_URL` usa pooler port 6543 (transaction mode)
- [ ] `DATABASE_URL_DIRECT` usa port 5432 (para migrations)

## Análise de Performance
```typescript
// Usar EXPLAIN ANALYZE via Supabase Dashboard ou Drizzle Studio
// Identificar Seq Scan em tabelas grandes → criar índice
// Identificar Nested Loop custoso → verificar índices em FK columns
```
