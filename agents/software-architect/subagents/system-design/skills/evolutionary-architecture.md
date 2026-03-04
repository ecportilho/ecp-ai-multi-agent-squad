# Skill — evolutionary-architecture

## Objetivo
Projetar a arquitetura para mudança, com fitness functions e preferência por decisões reversíveis.

## Arquitetura do o produto
- Monolito modular tRPC + Drizzle + Supabase
- Módulos: boards, cards, users, notifications
- Persistência: Supabase PostgreSQL (evolutivo para banco relacional no futuro)
- Front End: Next.js 15 App Router (apps/web)

## Output
```json
{
  "padrao": "monolito-modular",
  "modulos": [],
  "fitness_functions": [
    { "criterio": "tempo de resposta < 200ms", "como_medir": "..." }
  ],
  "decisoes_reversiveis": [],
  "proximos_passos_evolutivos": []
}
```
