# Skill: change-approver

## Objetivo
Revisar a GMUD e a análise de risco e emitir o parecer formal de aprovação, rejeição ou
deferimento da mudança. É o último passo antes do deploy em produção ser autorizado.

## Autoridade e Responsabilidade
O Change Manager Subagent tem autoridade para:
- **APROVAR** — autorizar o deploy dentro da janela planejada
- **APROVAR COM CONDIÇÕES** — autorizar com requisitos adicionais obrigatórios
- **DEFERIR** — postergar para outra janela ou até condições serem atendidas
- **REJEITAR** — bloquear a mudança até nova GMUD ser submetida com correções

> Nenhum agente ou humano pode fazer deploy em produção sem parecer de APROVADA ou
> APROVADA COM CONDIÇÕES nesta skill. Esta é uma regra inviolável do processo.

---

## Critérios de Decisão

### APROVAR diretamente quando:
- Score de risco 🟢 Baixo (6–10) E
- Todos os itens do checklist estão OK E
- Plano de rollback está documentado E
- Janela de execução está dentro do horário permitido

### APROVAR COM CONDIÇÕES quando:
- Score de risco 🟡 Médio (11–16) E
- Existem condições específicas que reduzem o risco se cumpridas E
- As condições são verificáveis antes ou durante a execução

Exemplos de condições comuns:
- "Executar apenas após confirmar backup manual do banco"
- "Usar feature flag com rollout de 10% nas primeiras 2 horas"
- "Monitorar Sentry por 30 minutos (não 15) após o deploy"
- "Ter desenvolvedor responsável disponível por 1 hora após o deploy"
- "Executar migration em horário de menor tráfego (ex: 2h–4h)"

### DEFERIR quando:
- Janela de execução é inadequada (final de semana, véspera de feriado) E a mudança
  não é emergencial
- Falta documentação obrigatória na GMUD (plano de rollback, análise de impacto)
- Há dependência de outra mudança que ainda não foi executada
- O Error Budget dos SLOs está abaixo de 25% — freeze ativo

### REJEITAR quando:
- Score de risco 🔴 Crítico (23–30) sem mitigações adequadas
- Checklist tem itens BLOQUEANTES não resolvidos (CI falhando, sem PR review, sem testes)
- Plano de rollback inexistente para mudança de alto risco
- Violação de política de segurança identificada (ex: secret hardcoded, auth bypass)
- Migration irreversível sem backup confirmado

---

## Tratamento por Tipo de Mudança

### Mudança Standard (pré-aprovada)
Mudanças de baixo risco que seguem um padrão já aprovado não precisam passar pelo
Change Manager — são aprovadas automaticamente se o checklist automático passar.

Exemplos de mudanças Standard:
- Atualização de dependência de patch version (ex: 1.2.3 → 1.2.4)
- Correção de typo em texto da interface
- Atualização de variável de ambiente não-crítica
- Deploy de feature protegida por feature flag (já aprovada anteriormente)

Critério Standard:
- Score de risco ≤ 8 E
- PR com CI passando E
- PR com aprovação de 1 revisor

### Mudança Emergencial (hotfix)
Para incidentes em produção que exigem correção imediata:

1. GMUD deve ser criada mesmo em emergência — pode ser simplificada
2. Risk assessor executa avaliação acelerada (foco nos riscos críticos)
3. Change Manager emite parecer em < 15 minutos
4. HITL humano obrigatório — o responsável técnico deve aprovar manualmente
5. GMUD completa é preenchida retroativamente após a resolução

---

## Template do Parecer

```markdown
## Parecer do Change Manager — GMUD-[NNN]

**Data/Hora do Parecer:** [YYYY-MM-DD HH:mm]
**Change Manager:** Change Manager Subagent

---

### Resumo da Avaliação

| Item | Resultado |
|------|---------|
| Tipo de mudança | [Normal / Standard / Emergencial] |
| Score de risco | [n]/30 — [🟢 Baixo / 🟡 Médio / 🟠 Alto / 🔴 Crítico] |
| Checklist de pré-requisitos | [✅ Completo / ⚠️ Pendências / ❌ Bloqueantes] |
| Plano de rollback | [✅ Documentado / ❌ Ausente] |
| Janela de execução | [✅ Adequada / ⚠️ Atenção / ❌ Inadequada] |
| Error budget status | [✅ > 50% / ⚠️ 25–50% / ❌ < 25%] |

---

### Riscos Principais Identificados
1. [Risco 1 — probabilidade × impacto — mitigação planejada]
2. [Risco 2 — ...]

---

### ✅ DECISÃO: [APROVADA / APROVADA COM CONDIÇÕES / DEFERIDA / REJEITADA]

**Justificativa:**
[Explicação clara da decisão, referenciando os critérios acima]

**Condições obrigatórias (se "APROVADA COM CONDIÇÕES"):**
- [ ] [Condição 1 — deve ser verificada ANTES de iniciar o deploy]
- [ ] [Condição 2 — deve ser verificada DURANTE o deploy]
- [ ] [Condição 3 — deve ser verificada APÓS o deploy]

**Janela de execução autorizada:**
[Data e horário de início] até [Data e horário de fim]

**Validade desta aprovação:**
[Ex: "Esta aprovação é válida por 48 horas. Após esse prazo, nova avaliação é necessária."]

**Instruções para execução:**
1. [Instrução específica para esta mudança]
2. [...]

**Ações de monitoramento pós-deploy:**
- Monitorar Sentry por [X] minutos após o deploy
- Verificar New Relic p95 < 500ms
- [Monitoramento específico desta mudança]

**Em caso de anomalia:**
- Iniciar rollback imediatamente se [condição de rollback]
- Notificar via [canal] imediatamente
- Abrir incidente no Sentry com tag `change:GMUD-[NNN]`

---

*Parecer emitido pelo Change Manager Subagent*
*GMUD arquivada em: `docs/gmud/GMUD-[NNN].md`*
```

---

## Gate de Aprovação no Pipeline (integração CI/CD)

O `pipeline-builder` deve incluir um step `change-gate` que verifica a existência de
aprovação antes do job de deploy em produção:

```yaml
# .github/workflows/deploy-production.yml
jobs:
  change-gate:
    name: Change Management Gate
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Verify GMUD approval
        # NOTA: Este step roda em ubuntu-latest no GitHub Actions (CI), não localmente.
        # Comandos Unix (find, grep) são válidos aqui porque o runner é Linux.
        run: |
          # Verificar se existe GMUD aprovada para este PR/commit
          GMUD_FILE=$(find docs/gmud -name "GMUD-*.md" -newer docs/gmud/registro.md | head -1)

          if [ -z "$GMUD_FILE" ]; then
            echo "❌ BLOQUEADO: Nenhuma GMUD encontrada para este deploy"
            echo "Criar GMUD via Change Manager Subagent antes de fazer deploy em produção"
            exit 1
          fi

          GMUD_STATUS=$(grep -m1 "Status" "$GMUD_FILE" | grep -o "Aprovada" || echo "")

          if [ -z "$GMUD_STATUS" ]; then
            echo "❌ BLOQUEADO: GMUD encontrada mas não está APROVADA"
            echo "Arquivo: $GMUD_FILE"
            echo "Aguardar aprovação do Change Manager antes de fazer deploy"
            exit 1
          fi

          echo "✅ GMUD aprovada encontrada: $GMUD_FILE"
          echo "Deploy autorizado para produção"

  deploy-production:
    name: Deploy to Production
    needs: [quality, change-gate]  # ← change-gate obrigatório
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      # ... steps de deploy
```

---

## Matriz de Decisão Rápida

| Score | CI | PR Review | E2E | Rollback | Decisão |
|-------|----|-----------|----|---------|---------|
| ≤10 | ✅ | ✅ | ✅ | ✅ | ✅ APROVAR |
| ≤10 | ✅ | ✅ | ❌ | ✅ | ⚠️ APROVAR COM CONDIÇÕES |
| ≤10 | ❌ | qualquer | qualquer | qualquer | ❌ REJEITAR |
| 11–16 | ✅ | ✅ | ✅ | ✅ | ⚠️ APROVAR COM CONDIÇÕES |
| 11–16 | ✅ | ✅ | ❌ | ✅ | ⏸️ DEFERIR |
| 17–22 | ✅ | ✅ | ✅ | ✅ | ⚠️ APROVAR COM CONDIÇÕES (rigorosas) |
| 17–22 | qualquer | qualquer | ❌ | qualquer | ❌ REJEITAR |
| ≥23 | qualquer | qualquer | qualquer | qualquer | ❌ REJEITAR |

---

## Output JSON
```json
{
  "gmud_id": "GMUD-001",
  "decision": "approved | approved_with_conditions | deferred | rejected",
  "risk_level": "low | medium | high | critical",
  "conditions": [],
  "authorized_window": {
    "start": "",
    "end": ""
  },
  "approval_validity_hours": 48,
  "post_deploy_monitoring_minutes": 15,
  "rollback_triggers": [],
  "decided_at": "",
  "decided_by": "Change Manager Subagent",
  "deploy_authorized": true
}
```
