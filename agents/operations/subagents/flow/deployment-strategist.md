# Skill: deployment-strategist

## Objetivo
Definir e executar estratégia de deploy para web (Vercel) e mobile (EAS).

## Deploy Web — Vercel
- Conectar repositório GitHub ao Vercel
- Deploy automático em push para `main` → produção
- Preview deploy automático em todo PR
- Environment variables configuradas no dashboard Vercel
- Edge network com ponto de presença em São Paulo

## Deploy Mobile — EAS
```bash
# Profiles em eas.json
{
  "build": {
    "development": { "distribution": "internal", "ios": { "simulator": true } },
    "preview": { "distribution": "internal" },
    "production": { "distribution": "store" }
  }
}

# Comandos
eas build --platform ios --profile preview
eas build --platform android --profile preview
eas submit --platform ios --latest        # App Store
eas submit --platform android --latest    # Google Play
eas update --branch preview               # OTA update (sem store review)
```

## Rollback
- Web: Vercel → Deployments → Promote anterior para produção
- Mobile: `eas update --branch production --message "rollback"` (apenas JS, não native)

---

## Gate de Mudança (GMUD) — Obrigatório Antes de Todo Deploy em Produção

Nenhum deploy em produção ocorre sem GMUD aprovada pelo Change Manager Subagent.

### Fluxo de deploy com GMUD
```
1. Operations cria GMUD via change-manager → gmud-writer
2. Change Manager avalia riscos via risk-assessor
3. Change Manager emite parecer via change-approver
4. Se APROVADA → pipeline job change-gate passa → deploy autorizado
5. Se REJEITADA/DEFERIDA → pipeline bloqueado até nova GMUD aprovada
```

### Tipos e aprovação
| Tipo | Aprovação | Deploy mobile via OTA? |
|------|-----------|----------------------|
| Standard (baixo risco, padrão) | Automática via checklist | Sim |
| Normal | Change Manager obrigatório | Sim, após aprovação |
| Emergencial (hotfix) | Change Manager + HITL humano | Sim, prioridade máxima |

### Localização das GMUDs
`{REPO_DESTINO}/docs/gmud/`
