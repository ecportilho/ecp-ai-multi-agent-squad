# Skill — rendering-strategist

## Objetivo
Definir estratégia de rendering no Next.js 15 App Router (Server Components vs Client Components).

## Estratégia do o produto
- Server Components (default): sem JS no bundle do cliente
- Dados carregados via fetch após DOMContentLoaded
- Skeleton screens durante carregamento
- Atualização incremental do DOM (sem full re-render)
