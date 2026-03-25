---
name: product-metrics-designer
description: >
  Definir e instrumentar eventos de produto no PostHog: funnels, retenção, adoção de features e KRs. Use ao instrumentar novas features, ao revisar métricas de produto, ou ao preparar o dashboard de Fase 04.
---

# Skill: product-metrics-designer

## Objetivo
Definir, instrumentar e documentar todas as métricas de produto — uso, outcomes, adoção de funcionalidades e comportamento dos usuários — conectando cada métrica aos KRs da Fase 01.

## Princípio Central
Cada métrica deve responder a uma pergunta de negócio real.
Nunca medir por medir — toda métrica tem um dono, uma meta e uma ação associada quando sai do target.

---

## 1. Taxonomia de Métricas de Produto

### 1.1 Métricas de Aquisição e Ativação
| Métrica | Definição | Fonte | Frequência |
|---------|-----------|-------|-----------|
| Novos usuários | Contas criadas no período | Supabase `auth.users` | Diária |
| Taxa de ativação | % de novos usuários que completaram onboarding | PostHog funnel | Semanal |
| Time to first value | Tempo até o usuário realizar a primeira ação de valor | PostHog | Semanal |
| Origem de aquisição | Canal que trouxe o usuário | PostHog `$referring_domain` | Mensal |

### 1.2 Métricas de Engajamento e Uso
| Métrica | Definição | Fonte | Frequência |
|---------|-----------|-------|-----------|
| DAU / MAU | Usuários ativos por dia / mês | PostHog `user_signed_in` | Diária |
| Ratio DAU/MAU | Stickiness — quanto % dos mensais voltam diariamente | Calculado | Semanal |
| Sessões por usuário | Média de sessões por usuário ativo | PostHog | Semanal |
| Duração média de sessão | Tempo médio de cada sessão | PostHog | Semanal |
| Ações por sessão | Quantas ações relevantes por visita | PostHog | Semanal |

### 1.3 Adoção de Funcionalidades
| Métrica | Definição | Fonte | Frequência |
|---------|-----------|-------|-----------|
| Adoção por feature | % de usuários ativos que usaram cada funcionalidade | PostHog | Semanal |
| Breadth of adoption | Quantas funcionalidades diferentes cada usuário usa | PostHog | Mensal |
| Feature discovery rate | % que encontrou a feature sem ajuda | PostHog funil | Semanal |
| Funil por funcionalidade | Inicio → meio → conclusão de cada fluxo | PostHog funil | Semanal |

### 1.4 Outcomes e Resultados de Negócio
| Métrica | Definição | Fonte | Frequência | KR Associado |
|---------|-----------|-------|-----------|-------------|
| [KR-01 métrica] | [definição] | [fonte] | [freq] | KR-01 |
| [KR-02 métrica] | [definição] | [fonte] | [freq] | KR-02 |
> ⚠️ Preencher com os KRs reais definidos na Fase 01

### 1.5 Retenção e Saúde
| Métrica | Definição | Fonte | Frequência |
|---------|-----------|-------|-----------|
| Retenção D1/D7/D30 | % de usuários que voltaram em 1/7/30 dias | PostHog cohort | Mensal |
| Churn rate | % de usuários que pararam de usar | PostHog | Mensal |
| NPS implícito | Comportamento que indica satisfação (retorno, indicação) | PostHog | Mensal |

---

## 2. Instrumentação com PostHog

### 2.1 Eventos a Capturar por Funcionalidade

Para cada funcionalidade do produto, instrumentar no mínimo:

```typescript
// Padrão de nomenclatura: [funcionalidade]_[ação]_[resultado]
// Exemplos:

// Pix
posthog.capture('pix_transfer_started',     { method: 'cpf' | 'email' | 'phone' | 'random' });
posthog.capture('pix_transfer_completed',   { amount_cents: 15000, method: 'cpf' });
posthog.capture('pix_transfer_failed',      { reason: 'insufficient_balance' | 'key_not_found' | 'timeout' });
posthog.capture('pix_key_registered',       { type: 'cpf' | 'email' | 'phone' | 'random' });

// Extrato
posthog.capture('statement_viewed',         { period: '7d' | '30d' | '90d' | 'custom' });
posthog.capture('transaction_detail_opened',{ type: 'pix' | 'ted' | 'payment' | 'purchase' });
posthog.capture('statement_filtered',       { filter_type: 'category' | 'period' | 'value' });

// Cartões
posthog.capture('card_viewed',              { card_type: 'virtual' | 'physical' });
posthog.capture('card_blocked',             { reason: 'lost' | 'stolen' | 'precaution' });
posthog.capture('card_limit_viewed',        {});

// Regras SEMPRE seguir:
// ✅ snake_case para nomes de eventos
// ✅ Propriedades numéricas como integers (amount_cents, não amount)
// ❌ NUNCA incluir PII: email, CPF, nome, número de conta
// ❌ NUNCA incluir tokens ou senhas
```

### 2.2 Funnels de Conversão a Configurar no PostHog

```
Funil 1 — Onboarding:
  app_opened → account_created → email_verified → first_login → onboarding_completed

Funil 2 — Primeira transação Pix:
  pix_tab_opened → pix_transfer_started → pix_key_entered → pix_amount_entered →
  pix_transfer_confirmed → pix_transfer_completed

Funil 3 — Cadastro de chave Pix:
  pix_keys_viewed → pix_key_add_started → pix_key_type_selected →
  pix_key_verified → pix_key_registered

Funil 4 — Pagamento de boleto:
  payments_tab_opened → barcode_scanned → payment_reviewed →
  payment_confirmed → payment_completed
```

### 2.3 Cohorts Importantes
```
Cohort "Power Users": usuários com > 10 transações nos últimos 30 dias
Cohort "At Risk": usuários ativos há >30 dias sem login nos últimos 7 dias
Cohort "New Users": criados nos últimos 7 dias
Cohort "Feature Adopters [X]": usuários que usaram a feature X ao menos 1x
```

---

## 3. Output da Skill

```json
{
  "metrics_catalog": {
    "acquisition": [],
    "engagement": [],
    "feature_adoption": [],
    "outcomes": [],
    "retention": []
  },
  "posthog_events": [],
  "funnels": [],
  "cohorts": [],
  "kr_mapping": [
    { "kr_id": "kr-01", "metric": "", "target": "", "current": "" }
  ],
  "dashboard_widgets": []
}
```
