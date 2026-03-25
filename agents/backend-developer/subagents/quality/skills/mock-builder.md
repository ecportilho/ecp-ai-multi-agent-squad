---
name: mock-builder
description: >
  Criar mocks tipados para Drizzle, Supabase Auth e dependências externas nos testes Vitest. Use ao escrever testes unitários que precisam isolar chamadas ao banco ou serviços externos.
---

# Skill: mock-builder

## Objetivo
Criar mocks tipados para Drizzle, Supabase e dependências externas nos testes Vitest.

## Padrão
Usar vi.mock() para mockar db, supabase, upstash. Mocks devem ser tipados — nunca usar any.
