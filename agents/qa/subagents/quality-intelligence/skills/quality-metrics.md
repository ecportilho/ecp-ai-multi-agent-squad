---
name: quality-metrics
description: >
  Medir e reportar métricas de qualidade: cobertura, rastreabilidade de ACs, flakiness e bug escape rate. Use antes do HITL #10 para gerar o relatório de qualidade que autoriza ou bloqueia o deploy.
---

# Skill — quality-metrics

## Objetivo
Coletar, calcular e reportar métricas de qualidade de testes — cobertura por camada,
rastreabilidade AC → teste, bugs escapados, flakiness e tendência — conectando
cada número a uma ação concreta quando sai do target.

---

## 1. Métricas de Cobertura

### Como coletar
```bash
# Gerar relatório de cobertura (todos os pacotes)
pnpm test:coverage

# Relatório consolidado — exportado automaticamente pelo CI
# Localização: packages/api/coverage/ e apps/web/coverage/
# Formatos: text (terminal), html (browser), lcov (Codecov), json-summary
```

### Thresholds e alertas

| Pacote | Métrica | Target | Alerta | Ação |
|--------|---------|--------|--------|------|
| `api/services` | Lines | ≥ 80% | < 80% | Bloquear PR + identificar arquivos descobertos |
| `api/services` | Branches | ≥ 75% | < 75% | Bloquear PR + adicionar testes de condicionais |
| `api/domain` | Lines | ≥ 85% | < 85% | Bloquear PR |
| `web/components` | Lines | ≥ 75% | < 75% | Bloquear PR |
| `web/hooks` | Lines | ≥ 80% | < 80% | Bloquear PR |

> Cobertura abaixo do threshold **bloqueia o build automaticamente** — configurado no `vitest.config.ts`.

### Como identificar o que está sem cobertura
```bash
# Abrir relatório HTML interativo
open packages/api/coverage/index.html

# Linhas sem cobertura aparecem em vermelho
# Branches não testados aparecem em amarelo
# Priorizar: funções com 0% cobertura e condicionais críticos (if/else em regras de negócio)
```

---

## 2. Rastreabilidade AC → Caso de Teste → Implementação

### Matriz de Rastreabilidade
Gerar e manter esta matriz por história — atualizar a cada Sprint:

```markdown
# Rastreabilidade de Testes — [Sprint / Release]

| AC | Tipo | CT | Arquivo de Teste | Status CI | Cobertura |
|----|------|----|-----------------|-----------|-----------|
| AC-01 | Unit | CT-001 | pix.service.test.ts:45 | ✅ | 100% |
| AC-01 | E2E  | CT-002 | pix-transfer.spec.ts:12 | ✅ | — |
| AC-05 | Unit | CT-010 a CT-014 | pix.service.test.ts:89 | ✅ | 100% |
| AC-06 | Unit | CT-020 | pix.service.test.ts:120 | ✅ | 100% |
| AC-06 | E2E  | CT-021 | pix-transfer.spec.ts:58 | ✅ | — |
| AC-08 | Unit | CT-025 | pix.service.test.ts:145 | ✅ | 100% |
| RN-03 | Unit | CT-030 | pix.service.test.ts:162 | ✅ | 100% |
| **AC-07** | Unit | **—** | **—** | **❌ SEM TESTE** | **0%** |
```

> AC-07 sem teste é um gap de rastreabilidade — deve ser adicionado antes do deploy.

### Como verificar gaps de rastreabilidade
```bash
# Listar todos os ACs sem teste correspondente
grep -r "AC-[0-9][0-9]" docs/gmud/ agents/ | \
  grep -v ".test.ts" | \
  grep -v ".spec.ts"

# Verificar se cada describe() do test suite referencia um AC
grep -r "describe.*AC-" packages/api/src --include="*.test.ts"
```

---

## 3. Métricas de Bugs

### Bug Escape Rate (taxa de bugs chegando à produção)

```
Bug Escape Rate = bugs encontrados em produção / (bugs em QA + bugs em produção)

Target: < 10%
Alerta: > 15% → revisão do processo de QA obrigatória
```

| Período | Bugs em QA | Bugs em Produção | Escape Rate | Status |
|---------|-----------|-----------------|-------------|--------|
| [mês] | [n] | [n] | [%] | ✅/⚠️/❌ |

### Bug Distribution por Componente
Identificar os componentes com maior concentração de bugs:

```
Componentes mais problemáticos (últimos 90 dias):
1. PixService — 8 bugs (3 críticos)
2. InvoiceService — 5 bugs (1 crítico)
3. AuthService — 2 bugs (0 críticos)

→ PixService precisa de revisão de testes e talvez refatoração
```

### Severidade e MTTR

| Severidade | Definição | MTTR Target | MTTR Atual |
|-----------|-----------|------------|-----------|
| Crítico | Perda de dados ou indisponibilidade total | < 2 horas | [atual] |
| Alto | Funcionalidade core quebrada | < 8 horas | [atual] |
| Médio | Funcionalidade degradada mas workaround existe | < 3 dias | [atual] |
| Baixo | Cosmético ou inconveniência | < 2 semanas | [atual] |

---

## 4. Métricas de Estabilidade dos Testes (Flakiness)

```
Flaky Test Rate = testes que falharam sem mudança de código / total de runs

Target: 0% (zero tolerância para testes flaky)
Qualquer flake deve ser corrigido antes de novas histórias
```

### Como detectar testes flaky no GitHub Actions
```yaml
# No CI, repetir testes com retry para identificar flakes
- name: Detect flaky tests
  run: pnpm test -- --reporter=verbose --retry=2
  # Se um teste passa na segunda tentativa → É FLAKY → Abrir issue imediatamente
```

### Causas comuns e correções

| Causa | Correção |
|-------|---------|
| Dependência de ordem de execução | `vi.clearAllMocks()` no `beforeEach` |
| Timeout em chamadas assíncronas | `await waitFor(...)` com timeout adequado |
| Data/hora hardcoded | `vi.setSystemTime()` nos testes time-sensitive |
| Estado global vazando entre testes | Isolar estado em `beforeEach`/`afterEach` |
| Race conditions no E2E | `await page.waitForSelector(...)` antes de asserções |

---

## 5. Métricas de Execução do CI

| Métrica | Target | Alerta |
|---------|--------|--------|
| Duração total do pipeline | < 15 min | > 20 min |
| Duração dos unit tests | < 3 min | > 5 min |
| Duração dos E2E | < 10 min | > 15 min |
| Taxa de sucesso do CI | > 95% | < 90% |
| Testes paralelos utilizados | > 80% da capacidade | — |

---

## 6. Relatório Semanal de Qualidade

Gerar ao final de cada Sprint ou semanalmente:

```markdown
# Relatório de Qualidade — Semana [N]

## Resumo Executivo
| Métrica | Esta semana | Semana anterior | Tendência |
|---------|------------|-----------------|-----------|
| Cobertura API services | 83% | 81% | ↑ Melhorando |
| Cobertura Web components | 78% | 76% | ↑ Melhorando |
| Bug Escape Rate | 8% | 12% | ↑ Melhorando |
| Testes flaky | 0 | 2 | ↑ Melhorando |
| ACs sem cobertura de teste | 2 | 5 | ↑ Melhorando |

## Gaps Identificados
- AC-07 de STORY-14 ainda sem teste unitário — responsável: Backend Dev
- Cobertura de branches em `CardService.calculateLimit()` = 60% — abaixo do threshold

## Ações para Próxima Semana
- [ ] Implementar CT para AC-07 — Backend Dev — até [data]
- [ ] Aumentar cobertura de branches em CardService — Backend Dev — até [data]
- [ ] Revisar E2E flaky identificado na semana passada — QA — até [data]

## Bugs da Semana
- 3 bugs encontrados em QA (2 médios, 1 baixo) — todos corrigidos
- 0 bugs chegaram a produção — Escape Rate: 0%
```

---

## Output JSON

```json
{
  "period": "2024-03-week-1",
  "coverage": {
    "api_services_lines": 83,
    "api_services_branches": 78,
    "api_domain_lines": 88,
    "web_components_lines": 78,
    "web_hooks_lines": 82
  },
  "traceability": {
    "total_acs": 45,
    "acs_with_unit_test": 43,
    "acs_with_e2e": 28,
    "acs_without_any_test": 2
  },
  "bugs": {
    "found_in_qa": 3,
    "escaped_to_production": 0,
    "escape_rate_pct": 0,
    "mttr_critical_hours": null,
    "mttr_high_hours": null
  },
  "flakiness": {
    "flaky_tests_count": 0,
    "flaky_tests": []
  },
  "ci": {
    "pipeline_duration_avg_min": 12,
    "success_rate_pct": 98
  },
  "actions": []
}
```
