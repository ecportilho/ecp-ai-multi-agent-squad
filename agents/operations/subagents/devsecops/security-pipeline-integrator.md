# Skill: security-pipeline-integrator

## Objetivo
Integrar verificações de segurança no pipeline GitHub Actions.

## Checks de Segurança no CI
```yaml
- name: Security Audit
  run: pnpm audit --audit-level moderate

- name: Biome Security Rules
  run: pnpm lint
  # biome.json já inclui: noDangerouslySetInnerHtml, noExplicitAny
```

## Checklist de Segurança da API
- Rate limiting via Upstash em toda procedure tRPC
- Input validation via Zod em toda procedure
- NUNCA logar PII (email, CPF, tokens, senhas)
- Headers de segurança no middleware Next.js (X-Frame-Options, X-Content-Type-Options)
- RLS no Supabase como segunda linha de defesa
- Idempotency keys em operações financeiras críticas

## Dependências
```bash
# Rodar semanalmente via Dependabot ou GitHub Actions schedule
pnpm audit
pnpm outdated
```
