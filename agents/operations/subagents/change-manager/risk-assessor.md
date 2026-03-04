# Skill: risk-assessor

## Objetivo
Avaliar automaticamente os riscos de uma GMUD antes que o Change Manager emita o parecer.
Produz uma análise estruturada com score de risco e recomendações de mitigação.

## Quando Executar
Imediatamente após a GMUD ser criada pelo `gmud-writer` — antes da aprovação.

---

## Modelo de Avaliação de Risco

### Dimensões Avaliadas

Cada dimensão recebe uma pontuação de 1 (mínimo) a 5 (máximo risco):

#### 1. Complexidade Técnica
| Score | Critério |
|-------|---------|
| 1 | Mudança de configuração ou texto sem lógica nova |
| 2 | Feature isolada, sem tocar em código crítico existente |
| 3 | Mudança em múltiplos componentes interdependentes |
| 4 | Refatoração de código crítico ou mudança em arquitetura |
| 5 | Mudança no banco de dados com migration complexa ou alteração de autenticação |

#### 2. Abrangência do Impacto
| Score | Critério |
|-------|---------|
| 1 | Afeta <1% dos usuários (feature flag desabilitada por default) |
| 2 | Afeta uma funcionalidade secundária com poucos usuários |
| 3 | Afeta uma funcionalidade importante usada por 10–50% dos usuários |
| 4 | Afeta funcionalidade core (ex: Pix, Extrato) usada por >50% |
| 5 | Afeta toda a aplicação (auth, banco, infra global) |

#### 3. Reversibilidade
| Score | Critério |
|-------|---------|
| 1 | Totalmente reversível via feature flag em < 1 minuto |
| 2 | Rollback via Vercel em < 2 minutos, sem migration de banco |
| 3 | Rollback com migration de banco reversível (tempo > 5 min) |
| 4 | Rollback parcial — parte da mudança irreversível (ex: novos dados já gravados) |
| 5 | Irreversível ou rollback exige intervenção manual complexa |

#### 4. Cobertura de Testes
| Score | Critério |
|-------|---------|
| 1 | Cobertura > 90%, E2E cobrindo todos os fluxos afetados |
| 2 | Cobertura > 80%, E2E nos happy paths |
| 3 | Cobertura > 70%, sem E2E específico para esta mudança |
| 4 | Cobertura < 70% ou testes não executados |
| 5 | Sem testes automatizados para os componentes alterados |

#### 5. Histórico no Componente
| Score | Critério |
|-------|---------|
| 1 | Componente sem incidentes nos últimos 90 dias |
| 2 | Componente com 1 incidente menor nos últimos 90 dias |
| 3 | Componente com 2+ incidentes ou 1 incidente grave |
| 4 | Componente com histórico de instabilidade recorrente |
| 5 | Componente causou downtime ou perda de dados recentemente |

#### 6. Janela de Execução
| Score | Critério |
|-------|---------|
| 1 | Dentro da janela padrão (Ter–Qui, 10h–16h), baixo tráfego |
| 2 | Segunda ou sexta em horário comercial |
| 3 | Fora do horário comercial, não é emergência |
| 4 | Final de semana ou véspera de feriado |
| 5 | Emergencial em produção, sem janela planejada |

---

## Cálculo do Score Final

```
Score Total = (C + A + R + T + H + J)
C = Complexidade Técnica
A = Abrangência do Impacto
R = Reversibilidade
T = Cobertura de Testes
H = Histórico no Componente
J = Janela de Execução

Máximo possível = 30
```

### Classificação por Score

| Score Total | Nível de Risco | Cor | Decisão Recomendada |
|-------------|---------------|-----|---------------------|
| 6–10 | 🟢 Baixo | Verde | Aprovação direta |
| 11–16 | 🟡 Médio | Amarelo | Aprovação com condições |
| 17–22 | 🟠 Alto | Laranja | Aprovação com plano de mitigação obrigatório |
| 23–30 | 🔴 Crítico | Vermelho | Rejeição ou deferimento para revisão |

---

## Catálogo de Riscos por Tipo de Mudança

### Riscos de Migration de Banco de Dados
| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Lock de tabela durante migration | Média | Alto | Executar em janela noturna ou usar migration online (ADD COLUMN vs ALTER TYPE) |
| Migration irreversível (DROP) | Baixa | Crítico | Exigir backup confirmado antes; manter coluna como nullable por 1 ciclo antes de dropar |
| Dados inválidos após ALTER TYPE | Média | Alto | Validar dados existentes antes; fazer em 3 etapas (add new col → populate → drop old) |
| Timeout em tabelas grandes | Média | Médio | Testar migration em staging com volume de dados similar ao produção |

### Riscos de Deploy de API (tRPC)
| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Breaking change em procedure existente | Média | Alto | Versionamento de API; manter procedure antiga enquanto clientes migram |
| Mudança de schema Zod incompatível com dados existentes | Baixa | Alto | Testar com dados reais de produção antes do deploy |
| Race condition em nova lógica de concorrência | Baixa | Crítico | Code review focado em concorrência; testes de carga antes do deploy |
| Cache desatualizado após mudança de schema | Alta | Médio | Invalidar cache Redis nas procedures afetadas |

### Riscos de Deploy de Front End
| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Regressão visual não detectada | Média | Médio | Screenshot tests em staging antes do deploy |
| Bundle size aumentou significativamente | Baixa | Médio | Verificar bundle analyzer antes do deploy |
| Core Web Vitals regrediu | Baixa | Médio | Comparar Vercel Analytics antes e depois |
| Feature nova com UX confusa para usuários | Média | Médio | Feature flag + rollout gradual (10% → 50% → 100%) |

### Riscos de Mudança de Infraestrutura
| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Variável de ambiente incorreta em produção | Média | Crítico | Checklist de variáveis; validar com `pnpm check-env` antes |
| Mudança de regra Cloudflare bloqueando tráfego legítimo | Baixa | Alto | Testar regra em modo "simulate" antes de aplicar |
| Limite de free tier atingido após mudança | Média | Alto | Monitorar consumo antes e depois; ter plano de upgrade |

### Riscos de Deploy Mobile (EAS)
| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Crash em dispositivos específicos (iOS version antiga) | Média | Alto | Testar em range de dispositivos no EAS Device Testing |
| OTA update quebra código nativo existente | Baixa | Crítico | OTA só para mudanças de JS; mudanças nativas exigem novo build |
| Rejeição nas stores por política violada | Baixa | Alto | Verificar guidelines antes de submeter |

---

## Checklist de Pré-Avaliação

Antes de calcular o score, verificar:

- [ ] PR tem todos os checks de CI passando? (typecheck, lint, tests, build)
- [ ] PR foi revisado por ao menos 1 outro desenvolvedor?
- [ ] Testes E2E (Playwright) foram executados para os fluxos afetados?
- [ ] Staging environment testado e aprovado?
- [ ] Existe plano de rollback documentado na GMUD?
- [ ] Janela de execução está dentro do horário permitido?
- [ ] Backup do banco de dados confirmado (se há migration)?
- [ ] Feature flag configurada (se mudança com impacto amplo)?

---

## Output da Avaliação de Risco

```markdown
## Análise de Risco — GMUD-[NNN]

### Scores por Dimensão

| Dimensão | Score (1–5) | Justificativa |
|----------|------------|---------------|
| Complexidade Técnica | [n] | [motivo] |
| Abrangência do Impacto | [n] | [motivo] |
| Reversibilidade | [n] | [motivo] |
| Cobertura de Testes | [n] | [motivo] |
| Histórico no Componente | [n] | [motivo] |
| Janela de Execução | [n] | [motivo] |
| **Total** | **[n]/30** | |

### Nível de Risco: [🟢 Baixo / 🟡 Médio / 🟠 Alto / 🔴 Crítico]

### Riscos Identificados
[Lista dos riscos aplicáveis do catálogo + riscos específicos desta mudança]

### Checklist de Pré-Avaliação
[Resultado de cada item — OK / PENDENTE / BLOQUEANTE]

### Recomendação para o Change Manager
[APROVAR / APROVAR COM CONDIÇÕES / DEFERIR / REJEITAR]

**Condições obrigatórias (se aplicável):**
[Lista de condições que devem ser atendidas antes ou durante a execução]
```

---

## Output JSON
```json
{
  "gmud_id": "GMUD-001",
  "risk_scores": {
    "complexity": 0,
    "impact": 0,
    "reversibility": 0,
    "test_coverage": 0,
    "history": 0,
    "window": 0,
    "total": 0
  },
  "risk_level": "low | medium | high | critical",
  "risks_identified": [],
  "checklist": {
    "ci_passing": true,
    "pr_reviewed": true,
    "e2e_tested": true,
    "staging_tested": true,
    "rollback_documented": true,
    "window_ok": true,
    "backup_confirmed": true,
    "feature_flag_ready": true
  },
  "blockers": [],
  "recommendation": "approve | approve_with_conditions | defer | reject",
  "conditions": []
}
```
