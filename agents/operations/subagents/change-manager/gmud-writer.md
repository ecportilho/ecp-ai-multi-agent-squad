---
name: gmud-writer
description: >
  Criar documento formal de Gestão de Mudança com todos os campos obrigatórios para deploy em produção. Use sempre que houver intenção de deploy em produção — é o primeiro passo do fluxo de GMUD.
---

# Skill: gmud-writer

## Objetivo
Criar o documento de Gestão de Mudança (GMUD) completo e estruturado para toda alteração
que será promovida ao ambiente de produção. A GMUD é o registro formal da mudança —
sem ela preenchida, a mudança não pode ser avaliada nem autorizada.

## Quando Executar
Toda vez que houver intenção de deploy em produção — seja release de nova feature,
hotfix, mudança de configuração, atualização de dependência ou alteração de infraestrutura.

## Localização do Output
```
{REPO_DESTINO}/docs/gmud/GMUD-[NNN].md
```
O número NNN é sequencial, zero-padded (GMUD-001, GMUD-002, ...).
Atualizar também `{REPO_DESTINO}/docs/gmud/registro.md`.

---

## Template Completo da GMUD

```markdown
# GMUD-[NNN] — [Título conciso descrevendo a mudança]

---

## 1. Identificação

| Campo | Valor |
|-------|-------|
| **Número** | GMUD-[NNN] |
| **Título** | [Título descritivo da mudança] |
| **Tipo** | Normal / Standard / Emergencial |
| **Status** | Rascunho / Aguardando Avaliação / Aprovada / Rejeitada / Deferida / Executada / Fechada |
| **Prioridade** | Baixa / Média / Alta / Crítica |
| **Solicitante** | [Agente ou pessoa que solicitou] |
| **Responsável técnico** | [Quem vai executar a mudança] |
| **Change Manager** | Change Manager Subagent |
| **Data de criação** | [YYYY-MM-DD HH:mm] |
| **Data planejada de execução** | [YYYY-MM-DD HH:mm] |
| **Duração estimada** | [em minutos] |
| **Janela de manutenção** | [início] até [fim] |

---

## 2. Descrição da Mudança

### 2.1 O que vai mudar?
[Descrição clara e objetiva do que será alterado em produção.
Ser específico: quais componentes, arquivos, configurações, dados serão afetados.]

### 2.2 Por que vai mudar? (Motivação)
[Justificativa de negócio ou técnica. Pode referenciar a história de usuário, bug, incidente
ou decisão técnica que originou esta mudança.]

### 2.3 Escopo da mudança

| Componente | Alterado? | Descrição |
|-----------|-----------|-----------|
| Front End Web (Next.js) | Sim / Não | [o que muda] |
| App Mobile (Expo/iOS) | Sim / Não | [o que muda] |
| App Mobile (Expo/Android) | Sim / Não | [o que muda] |
| API (tRPC) | Sim / Não | [o que muda] |
| Banco de dados (Supabase) | Sim / Não | [migrations, schema, dados] |
| Cache (Upstash Redis) | Sim / Não | [invalidações, configuração] |
| Variáveis de ambiente | Sim / Não | [quais variáveis] |
| Dependências (pnpm) | Sim / Não | [pacotes adicionados/atualizados/removidos] |
| Configuração de infraestrutura | Sim / Não | [Vercel, Cloudflare, Supabase config] |
| Feature flags (PostHog) | Sim / Não | [flags criadas, alteradas ou removidas] |

### 2.4 Artefatos relacionados
- Pull Request: [URL do PR no GitHub]
- Histórias relacionadas: [STORY-XXX, STORY-YYY]
- Épico: [EPIC-XXX]
- Incidente relacionado (se hotfix): [INC-XXX]

---

## 3. Análise de Impacto

### 3.1 Usuários afetados
| Segmento | Impacto | Tipo |
|---------|---------|------|
| [ex: Todos os usuários ativos] | [ex: Indisponibilidade < 30s durante deploy] | Interrupção momentânea / Sem impacto / Novo comportamento |
| [ex: Usuários em fluxo de Pix] | [ex: Possível erro se em mid-transaction] | Risco de perda de dados |

### 3.2 Sistemas e integrações afetados
| Sistema | Tipo de impacto | Mitigação |
|---------|----------------|-----------|
| [ex: Supabase PostgreSQL] | [ex: Migration pode travar tabela por 2–5s] | [ex: Executar em horário de baixo uso] |
| [ex: Upstash Redis] | [ex: Invalidação de cache] | [ex: Cache será reconstruído automaticamente] |
| [ex: API do Banco Central (Pix)] | [ex: Nenhum] | — |

### 3.3 Impacto nos SLOs
| SLO | Impacto esperado | Dentro do error budget? |
|-----|-----------------|------------------------|
| Disponibilidade API (≥ 99,5%) | [ex: ~30s de indisponibilidade] | [Sim / Não — calcular] |
| Latência p95 (< 500ms) | [Nenhum / Degradação temporária] | [Sim / Não] |
| Taxa de erro (< 0,5%) | [Possível spike durante rollout] | [Sim / Não] |

---

## 4. Análise de Risco

*Preenchida automaticamente pela skill `risk-assessor` — ver seção 4 do fluxo.*

| # | Risco | Probabilidade | Impacto | Severidade | Mitigação |
|---|-------|--------------|---------|-----------|-----------|
| R01 | [descrição do risco] | Baixa/Média/Alta | Baixo/Médio/Alto | 🟢/🟡/🟠/🔴 | [ação de mitigação] |
| R02 | ... | ... | ... | ... | ... |

**Nível de risco geral:** 🟢 Baixo / 🟡 Médio / 🟠 Alto / 🔴 Crítico

---

## 5. Plano de Execução

### 5.1 Pré-requisitos
- [ ] PR aprovado com todos os checks de CI passando (`pnpm check-all`)
- [ ] Testes de regressão E2E executados e aprovados (Playwright)
- [ ] GMUD avaliada e aprovada pelo Change Manager
- [ ] Backup do banco de dados confirmado (Supabase faz automático diário)
- [ ] Equipe de suporte notificada
- [ ] Feature flag configurada (se aplicável para rollout gradual)
- [ ] [Pré-requisito específico desta mudança]

### 5.2 Passos de execução

| # | Passo | Responsável | Duração estimada | Verificação |
|---|-------|------------|-----------------|-------------|
| 1 | [ex: Confirmar backup automático do Supabase] | Operations | 2 min | Verificar no painel Supabase → Backups |
| 2 | [ex: Merge do PR para `main` no GitHub] | Dev responsável | 1 min | CI pipeline iniciado automaticamente |
| 3 | [ex: Aguardar pipeline CI passar] | Operations | 5–8 min | GitHub Actions: todos os steps ✅ |
| 4 | [ex: Aguardar deploy automático no Vercel] | Operations | 2–3 min | Vercel Dashboard: deployment succeeded |
| 5 | [ex: Executar migration de banco] | Operations | 2 min | `pnpm db:migrate` — sem erros |
| 6 | [ex: Verificar smoke tests em produção] | QA | 5 min | Cenários críticos passando |
| 7 | [ex: Monitorar Sentry por 15 minutos] | Operations | 15 min | Zero novos erros críticos |
| 8 | [ex: Confirmar métricas no New Relic] | Operations | 5 min | p95 < 500ms, error rate < 0,5% |

### 5.3 Critérios de sucesso
- [ ] Vercel deployment status: SUCCESS
- [ ] Zero erros novos críticos no Sentry nos primeiros 15 min
- [ ] Latência p95 < 500ms no New Relic
- [ ] Smoke tests manuais dos fluxos críticos passando
- [ ] [Critério específico desta mudança]

---

## 6. Plano de Rollback

### 6.1 Gatilhos para rollback
Iniciar rollback imediatamente se qualquer condição abaixo for verdadeira:
- Taxa de erro > 2% por mais de 5 minutos após o deploy
- Latência p95 > 2.000ms por mais de 5 minutos
- Fluxo crítico inoperante (ex: Pix indisponível, login impossível)
- Qualquer perda de dados detectada
- [Condição específica desta mudança]

### 6.2 Passos de rollback

**Web (Vercel) — tempo estimado: 2 minutos**
1. Acessar Vercel Dashboard → Deployments
2. Identificar o deployment anterior (estável)
3. Clicar em "..." → "Promote to Production"
4. Aguardar propagação (~1 min)
5. Verificar que a versão anterior está ativa

**Mobile (EAS) — OTA update — tempo estimado: 5 minutos**
```bash
eas update --branch production --message "rollback: revert to [versão anterior]"
```
> ⚠️ Rollback mobile via OTA funciona apenas para mudanças de JavaScript.
> Mudanças em código nativo requerem nova submissão às stores.

**Banco de dados — tempo estimado: variável**
```bash
# Reverter última migration
pnpm db:migrate:rollback
```
> ⚠️ Rollback de migration só é possível se a migration for reversível.
> Migrations com DROP ou DELETE de dados podem ser irreversíveis — avaliar caso a caso.

**Feature flag — tempo estimado: 1 minuto**
- Acessar PostHog → Feature Flags → [flag da mudança] → Desabilitar
- A mudança é revertida instantaneamente para todos os usuários

### 6.3 Comunicação durante rollback
- Notificar equipe imediatamente via canal de incidentes
- Abrir incidente no Sentry
- Atualizar status page (se existir)
- Registrar timeline de eventos para postmortem

---

## 7. Comunicação

### 7.1 Notificações pré-mudança
| Público | Canal | Antecedência | Conteúdo |
|---------|-------|-------------|---------|
| [ex: Equipe técnica] | [ex: Slack #deployments] | [ex: 30 min] | [ex: "Deploy GMUD-001 iniciando em 30 min"] |
| [ex: Suporte ao cliente] | [ex: E-mail interno] | [ex: 1 hora] | [ex: "Manutenção planejada 15h-15h30"] |
| [ex: Usuários finais] | [ex: Banner no app] | [ex: 24 horas] | [ex: "Atualização programada amanhã às 15h"] |

### 7.2 Template de comunicação para usuários (se aplicável)
```
[Nome do produto] estará em manutenção programada em [data] das [início] às [fim].
Durante esse período, [descrição do impacto esperado].
Pedimos desculpas pelo inconveniente.
```

---

## 8. Histórico e Aprovação

| Evento | Data/Hora | Responsável | Observação |
|--------|-----------|------------|-----------|
| GMUD criada | [data] | Operations Agent | — |
| Análise de risco concluída | [data] | Change Manager Subagent | — |
| Submetida para aprovação | [data] | Operations Agent | — |
| **[APROVADA / REJEITADA / DEFERIDA]** | [data] | **Change Manager Subagent** | [justificativa] |
| Execução iniciada | [data] | [responsável] | — |
| Execução concluída | [data] | [responsável] | [sucesso / rollback] |
| GMUD fechada | [data] | Change Manager Subagent | — |

### Parecer do Change Manager
```
[Preenchido pela skill change-approver]
```

---

## 9. Lições Aprendidas (pós-execução)
> *Preencher após a execução da mudança.*

- O que foi bem?
- O que poderia ter sido melhor?
- A estimativa de tempo foi precisa?
- O plano de rollback foi necessário? Funcionou?
- Ações para o próximo processo de mudança:
```

---

## Registro Consolidado (`registro.md`)

Além do arquivo individual, atualizar o registro:

```markdown
# Registro de GMUDs — [Nome do Produto]

| GMUD | Título | Tipo | Status | Data Exec. | Risco | Resultado |
|------|--------|------|--------|-----------|-------|-----------|
| [GMUD-001](GMUD-001.md) | [título] | Normal | Executada | [data] | 🟡 Médio | ✅ Sucesso |
| [GMUD-002](GMUD-002.md) | [título] | Emergencial | Executada | [data] | 🟠 Alto | ⚠️ Rollback |
```

---

## Output JSON
```json
{
  "gmud_id": "GMUD-001",
  "title": "",
  "type": "Normal | Standard | Emergencial",
  "status": "Aguardando Avaliação",
  "priority": "Baixa | Média | Alta | Crítica",
  "planned_execution": "",
  "estimated_duration_min": 0,
  "components_affected": [],
  "risk_level": null,
  "requires_risk_assessment": true,
  "requires_change_manager_approval": true,
  "file": "{REPO_DESTINO}/docs/gmud/GMUD-001.md"
}
```
