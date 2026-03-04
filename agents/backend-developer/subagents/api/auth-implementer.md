# Skill: auth-implementer

## Objetivo
Implementar autenticação via Supabase Auth e proteger procedures tRPC.

## Context e Middleware (já no trpc.ts)
```typescript
// packages/api/src/trpc.ts — padrão do framework
// Context extrai o usuário do JWT Supabase automaticamente
// authMiddleware verifica ctx.user antes de processar a procedure
// protectedProcedure = publicProcedure + authMiddleware
```

## Fluxo de Auth
```
REGISTRO WEB:
  supabase.auth.signUp({ email, password })
  → Supabase cria user em auth.users
  → DB trigger cria registro na tabela de profiles
  → Email de confirmação enviado

LOGIN WEB:
  supabase.auth.signInWithPassword({ email, password })
  → JWT armazenado via cookies (SSR-safe)
  → Middleware Next.js valida JWT em toda request

LOGIN MOBILE:
  supabase.auth.signInWithPassword({ email, password })
  → JWT armazenado via expo-secure-store (NUNCA AsyncStorage)
  → Biometria via expo-local-authentication
```

## Regras
- NUNCA auth customizado — sempre Supabase Auth
- NUNCA JWT em localStorage no web — usar cookies SSR-safe
- NUNCA JWT em AsyncStorage no mobile — usar expo-secure-store
- RLS no Supabase como segunda linha de defesa
