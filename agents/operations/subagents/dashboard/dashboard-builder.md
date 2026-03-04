# Skill: dashboard-builder

## Objetivo
Gerar o arquivo HTML do dashboard operacional — standalone, sem servidor, com identidade o produto (conforme design_spec.md) — integrando métricas de produto e SRE em uma interface clara e navegável.

## Referência Visual Obrigatória
Ler antes de escrever qualquer HTML:
- `{REPO_DESTINO}/design_spec.md`
- `{REPO_DESTINO}/design_spec.md (protótipo de referência)`

## Localização do Output
```
{REPO_DESTINO}/docs/dashboard/index.html
{REPO_DESTINO}/docs/dashboard/assets/style.css
{REPO_DESTINO}/docs/dashboard/assets/charts.js
{REPO_DESTINO}/docs/dashboard/assets/data.js
{REPO_DESTINO}/docs/dashboard/README.md
```

---

## Estrutura do Dashboard

O dashboard é dividido em **4 seções** acessíveis pela sidebar:

| Seção | Ícone | Conteúdo |
|-------|-------|---------|
| Visão Geral | 🏠 | KPIs principais de produto e SRE lado a lado |
| Uso do Produto | 📈 | Engajamento, retenção, adoção de funcionalidades |
| Outcomes & KRs | 🎯 | OKRs com progresso, métricas de negócio |
| SRE & Técnico | ⚙️ | SLOs, DORA, latência, erros, infra |

---

## Template HTML Completo

```html
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard Operacional — [Nome do Produto]</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <!-- Chart.js via CDN -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>

  <!-- ═══════════════════════════════════════
       SIDEBAR
  ═══════════════════════════════════════ -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <span class="brand-mark">⬡</span>
      <div>
        <div class="brand-name">[Nome do Produto]</div>
        <div class="brand-sub">Dashboard Operacional</div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <a class="nav-item active" data-section="overview" onclick="showSection('overview')">
        <span class="nav-icon">🏠</span> Visão Geral
      </a>
      <a class="nav-item" data-section="product" onclick="showSection('product')">
        <span class="nav-icon">📈</span> Uso do Produto
      </a>
      <a class="nav-item" data-section="outcomes" onclick="showSection('outcomes')">
        <span class="nav-icon">🎯</span> Outcomes & KRs
      </a>
      <a class="nav-item" data-section="sre" onclick="showSection('sre')">
        <span class="nav-icon">⚙️</span> SRE & Técnico
      </a>
    </nav>

    <div class="sidebar-footer">
      <div class="update-label">Última atualização</div>
      <div class="update-time" id="last-updated">—</div>
      <div class="data-note">⚠️ Dados simulados<br>Ver README para conectar fontes reais</div>
    </div>
  </aside>

  <!-- ═══════════════════════════════════════
       MAIN
  ═══════════════════════════════════════ -->
  <main class="main">

    <!-- Topbar -->
    <header class="topbar">
      <div class="topbar-left">
        <h1 class="page-title" id="section-title">Visão Geral</h1>
        <select class="period-select" id="period-select" onchange="updatePeriod(this.value)">
          <option value="7d">Últimos 7 dias</option>
          <option value="30d" selected>Últimos 30 dias</option>
          <option value="90d">Últimos 90 dias</option>
        </select>
      </div>
      <div class="topbar-right">
        <div class="status-dot" id="system-status" title="Status do sistema"></div>
        <span class="status-label" id="system-status-label">Todos os sistemas operacionais</span>
      </div>
    </header>

    <!-- ─────────────────────────────────────
         SEÇÃO: VISÃO GERAL
    ───────────────────────────────────── -->
    <section class="content-section active" id="section-overview">

      <!-- KPIs de produto -->
      <div class="section-block">
        <h2 class="block-title">📊 Produto</h2>
        <div class="kpi-grid">
          <div class="kpi-card">
            <div class="kpi-label">Usuários Ativos (MAU)</div>
            <div class="kpi-value" id="kpi-mau">—</div>
            <div class="kpi-delta positive" id="kpi-mau-delta">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Usuários Ativos (DAU)</div>
            <div class="kpi-value" id="kpi-dau">—</div>
            <div class="kpi-delta" id="kpi-dau-delta">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Stickiness (DAU/MAU)</div>
            <div class="kpi-value" id="kpi-stickiness">—</div>
            <div class="kpi-delta" id="kpi-stickiness-delta">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Taxa de Ativação</div>
            <div class="kpi-value" id="kpi-activation">—</div>
            <div class="kpi-delta" id="kpi-activation-delta">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Retenção D30</div>
            <div class="kpi-value" id="kpi-retention">—</div>
            <div class="kpi-delta" id="kpi-retention-delta">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">North Star Metric</div>
            <div class="kpi-value" id="kpi-nsm">—</div>
            <div class="kpi-delta" id="kpi-nsm-delta">—</div>
          </div>
        </div>
      </div>

      <!-- KPIs de SRE -->
      <div class="section-block">
        <h2 class="block-title">⚙️ Sistema</h2>
        <div class="kpi-grid">
          <div class="kpi-card">
            <div class="kpi-label">Disponibilidade API</div>
            <div class="kpi-value" id="kpi-availability">—</div>
            <div class="kpi-bar-wrap"><div class="kpi-bar" id="kpi-availability-bar"></div></div>
            <div class="slo-target">SLO: ≥ 99,5%</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Latência p95 (API)</div>
            <div class="kpi-value" id="kpi-p95">—</div>
            <div class="slo-target">SLO: < 500ms</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Taxa de Erro</div>
            <div class="kpi-value" id="kpi-error-rate">—</div>
            <div class="slo-target">SLO: < 0,5%</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Error Budget Restante</div>
            <div class="kpi-value" id="kpi-error-budget">—</div>
            <div class="kpi-bar-wrap"><div class="kpi-bar lime" id="kpi-budget-bar"></div></div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">Deploy Frequency</div>
            <div class="kpi-value" id="kpi-deploy-freq">—</div>
            <div class="kpi-dora-badge" id="kpi-deploy-badge">—</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-label">LCP (Web Vitals)</div>
            <div class="kpi-value" id="kpi-lcp">—</div>
            <div class="slo-target">SLO: < 2,5s</div>
          </div>
        </div>
      </div>

    </section>

    <!-- ─────────────────────────────────────
         SEÇÃO: USO DO PRODUTO
    ───────────────────────────────────── -->
    <section class="content-section" id="section-product">

      <div class="section-block">
        <h2 class="block-title">Usuários Ativos — DAU/MAU</h2>
        <div class="chart-card wide">
          <canvas id="chart-dau-mau"></canvas>
        </div>
      </div>

      <div class="two-col">
        <div class="section-block">
          <h2 class="block-title">Retenção por Coorte</h2>
          <div class="chart-card">
            <canvas id="chart-retention"></canvas>
          </div>
        </div>
        <div class="section-block">
          <h2 class="block-title">Sessões por Usuário</h2>
          <div class="chart-card">
            <canvas id="chart-sessions"></canvas>
          </div>
        </div>
      </div>

      <div class="section-block">
        <h2 class="block-title">Adoção por Funcionalidade</h2>
        <div class="feature-adoption-list" id="feature-adoption-list">
          <!-- Gerado via JS -->
        </div>
      </div>

      <div class="section-block">
        <h2 class="block-title">Funis de Conversão</h2>
        <div class="funnel-grid" id="funnel-grid">
          <!-- Gerado via JS -->
        </div>
      </div>

    </section>

    <!-- ─────────────────────────────────────
         SEÇÃO: OUTCOMES & KRs
    ───────────────────────────────────── -->
    <section class="content-section" id="section-outcomes">

      <div class="section-block">
        <h2 class="block-title">OKRs — Progresso</h2>
        <div class="okr-list" id="okr-list">
          <!-- Gerado via JS a partir de data.js -->
        </div>
      </div>

      <div class="section-block">
        <h2 class="block-title">Tendência das Métricas de Outcome</h2>
        <div class="chart-card wide">
          <canvas id="chart-outcomes"></canvas>
        </div>
      </div>

    </section>

    <!-- ─────────────────────────────────────
         SEÇÃO: SRE & TÉCNICO
    ───────────────────────────────────── -->
    <section class="content-section" id="section-sre">

      <div class="section-block">
        <h2 class="block-title">SLOs — Status Atual</h2>
        <div class="slo-list" id="slo-list">
          <!-- Gerado via JS -->
        </div>
      </div>

      <div class="two-col">
        <div class="section-block">
          <h2 class="block-title">Latência API (p50 / p95 / p99)</h2>
          <div class="chart-card">
            <canvas id="chart-latency"></canvas>
          </div>
        </div>
        <div class="section-block">
          <h2 class="block-title">Taxa de Erros</h2>
          <div class="chart-card">
            <canvas id="chart-errors"></canvas>
          </div>
        </div>
      </div>

      <div class="section-block">
        <h2 class="block-title">DORA Metrics</h2>
        <div class="dora-grid" id="dora-grid">
          <!-- Gerado via JS -->
        </div>
      </div>

      <div class="two-col">
        <div class="section-block">
          <h2 class="block-title">Top 5 Erros (Sentry)</h2>
          <div class="error-list" id="error-list">
            <!-- Gerado via JS -->
          </div>
        </div>
        <div class="section-block">
          <h2 class="block-title">Saúde da Infraestrutura</h2>
          <div class="infra-list" id="infra-list">
            <!-- Gerado via JS -->
          </div>
        </div>
      </div>

    </section>

  </main>

  <script src="assets/data.js"></script>
  <script src="assets/charts.js"></script>
</body>
</html>
```

---

## assets/style.css

```css
/* ═══════════════════════════════════════
   o produto (conforme design_spec.md) — Dashboard Operacional
   Identidade: Dark + Verde-limão
═══════════════════════════════════════ */
:root {
  --bg:          #0b0f14;
  --surface:     #131c28;
  --surface-2:   #0f1620;
  --border:      #1c2836;
  --border-2:    #27364a;
  --text:        #eaf2ff;
  --text-2:      #a9b7cc;
  --muted:       #7b8aa3;
  --lime:        #b7ff2a;
  --lime-hover:  #9eea12;
  --lime-dim:    rgba(183,255,42,0.10);
  --lime-glow:   rgba(183,255,42,0.20);
  --success:     #3dff8b;
  --success-dim: rgba(61,255,139,0.10);
  --warning:     #ffcc00;
  --warning-dim: rgba(255,204,0,0.10);
  --danger:      #ff4d4d;
  --danger-dim:  rgba(255,77,77,0.10);
  --info:        #4da3ff;
  --info-dim:    rgba(77,163,255,0.10);
  --sidebar-w:   260px;
  --topbar-h:    60px;
  --font:        Inter, system-ui, sans-serif;
  --radius:      12px;
  --radius-sm:   8px;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; }
body {
  font-family: var(--font);
  background: var(--bg);
  color: var(--text);
  display: grid;
  grid-template-columns: var(--sidebar-w) 1fr;
  min-height: 100vh;
  -webkit-font-smoothing: antialiased;
}

/* ── Sidebar ───────────────────────── */
.sidebar {
  position: sticky; top: 0; height: 100vh;
  background: var(--surface);
  border-right: 1px solid var(--border);
  display: flex; flex-direction: column;
  overflow-y: auto;
}
.sidebar-brand {
  display: flex; align-items: center; gap: 12px;
  padding: 20px 16px; border-bottom: 1px solid var(--border);
}
.brand-mark { font-size: 24px; color: var(--lime); line-height: 1; }
.brand-name { font-size: 14px; font-weight: 700; }
.brand-sub  { font-size: 11px; color: var(--muted); margin-top: 2px; }

.sidebar-nav { display: flex; flex-direction: column; gap: 2px; padding: 16px 12px; flex: 1; }
.nav-item {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 12px; border-radius: var(--radius-sm);
  font-size: 13px; font-weight: 500; color: var(--text-2);
  cursor: pointer; user-select: none;
  transition: all 140ms ease; text-decoration: none;
}
.nav-item:hover { background: var(--surface-2); color: var(--text); }
.nav-item.active {
  background: var(--lime-dim); color: var(--lime);
  border-left: 3px solid var(--lime); padding-left: 9px;
}
.nav-icon { font-size: 15px; width: 20px; text-align: center; }

.sidebar-footer {
  padding: 16px; border-top: 1px solid var(--border);
  font-size: 11px;
}
.update-label { color: var(--muted); margin-bottom: 2px; }
.update-time  { color: var(--text-2); font-weight: 600; margin-bottom: 10px; }
.data-note    { color: var(--warning); line-height: 1.5; }

/* ── Main / Topbar ─────────────────── */
.main { display: flex; flex-direction: column; min-height: 100vh; overflow-x: hidden; }
.topbar {
  position: sticky; top: 0; z-index: 10;
  height: var(--topbar-h);
  background: rgba(11,15,20,0.85); backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 28px;
}
.topbar-left  { display: flex; align-items: center; gap: 16px; }
.topbar-right { display: flex; align-items: center; gap: 10px; }
.page-title   { font-size: 15px; font-weight: 600; }
.period-select {
  background: var(--surface); border: 1px solid var(--border-2);
  color: var(--text-2); font-size: 12px; font-family: var(--font);
  padding: 5px 10px; border-radius: var(--radius-sm); cursor: pointer;
}
.status-dot {
  width: 8px; height: 8px; border-radius: 50%;
  background: var(--success);
  box-shadow: 0 0 8px var(--success);
}
.status-dot.degraded { background: var(--warning); box-shadow: 0 0 8px var(--warning); }
.status-dot.down     { background: var(--danger);  box-shadow: 0 0 8px var(--danger); }
.status-label { font-size: 12px; color: var(--text-2); }

/* ── Sections ──────────────────────── */
.content-section { display: none; padding: 24px 28px; flex-direction: column; gap: 24px; }
.content-section.active { display: flex; }

.section-block { display: flex; flex-direction: column; gap: 14px; }
.block-title { font-size: 13px; font-weight: 600; color: var(--text-2); text-transform: uppercase; letter-spacing: 0.6px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }

/* ── KPI Cards ─────────────────────── */
.kpi-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.kpi-card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 18px 20px;
}
.kpi-label { font-size: 11px; color: var(--muted); font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
.kpi-value { font-size: 28px; font-weight: 700; color: var(--text); font-variant-numeric: tabular-nums; margin-bottom: 6px; }
.kpi-delta { font-size: 12px; font-weight: 600; }
.kpi-delta.positive { color: var(--success); }
.kpi-delta.negative { color: var(--danger); }
.kpi-delta.neutral  { color: var(--muted); }
.kpi-bar-wrap { height: 4px; background: var(--surface-2); border-radius: 2px; margin: 8px 0 4px; }
.kpi-bar { height: 100%; border-radius: 2px; background: var(--danger); transition: width 600ms ease; }
.kpi-bar.lime { background: var(--lime); }
.kpi-bar.ok   { background: var(--success); }
.slo-target { font-size: 11px; color: var(--muted); }
.kpi-dora-badge {
  display: inline-block; font-size: 10px; font-weight: 700;
  padding: 2px 8px; border-radius: 999px; margin-top: 4px;
}
.badge-elite  { background: var(--success-dim); color: var(--success); }
.badge-high   { background: var(--lime-dim);    color: var(--lime); }
.badge-medium { background: var(--warning-dim); color: var(--warning); }
.badge-low    { background: var(--danger-dim);  color: var(--danger); }

/* ── Charts ────────────────────────── */
.chart-card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 20px;
  max-height: 280px;
}
.chart-card.wide { max-height: 240px; }

/* ── Feature Adoption ──────────────── */
.feature-row {
  display: flex; align-items: center; gap: 14px;
  padding: 12px 16px; background: var(--surface);
  border: 1px solid var(--border); border-radius: var(--radius-sm);
  margin-bottom: 8px;
}
.feature-name  { font-size: 13px; font-weight: 600; min-width: 120px; }
.feature-bar-wrap { flex: 1; height: 6px; background: var(--surface-2); border-radius: 3px; }
.feature-bar   { height: 100%; border-radius: 3px; background: var(--lime); }
.feature-pct   { font-size: 13px; font-weight: 700; color: var(--lime); min-width: 42px; text-align: right; font-variant-numeric: tabular-nums; }
.feature-trend { font-size: 11px; min-width: 52px; text-align: right; }

/* ── Funnels ───────────────────────── */
.funnel-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
.funnel-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; }
.funnel-title { font-size: 12px; font-weight: 600; color: var(--text-2); margin-bottom: 14px; }
.funnel-step {
  display: flex; align-items: center; gap: 10px;
  padding: 8px 0; border-bottom: 1px solid var(--border);
  font-size: 12px;
}
.funnel-step:last-child { border-bottom: none; }
.funnel-step-name  { flex: 1; color: var(--text-2); }
.funnel-step-count { font-weight: 600; font-variant-numeric: tabular-nums; min-width: 50px; text-align: right; }
.funnel-step-pct   { color: var(--muted); min-width: 42px; text-align: right; font-size: 11px; }
.funnel-drop       { color: var(--danger); font-size: 10px; }

/* ── OKRs ──────────────────────────── */
.okr-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; margin-bottom: 16px; }
.okr-header { padding: 14px 20px; background: var(--lime-dim); border-bottom: 1px solid var(--border); }
.okr-objective { font-size: 14px; font-weight: 700; color: var(--lime); }
.kr-list       { padding: 12px 20px; display: flex; flex-direction: column; gap: 14px; }
.kr-item       {}
.kr-title      { font-size: 13px; font-weight: 600; margin-bottom: 6px; }
.kr-meta       { display: flex; justify-content: space-between; font-size: 11px; color: var(--muted); margin-bottom: 6px; }
.kr-progress-wrap { height: 6px; background: var(--surface-2); border-radius: 3px; }
.kr-progress-fill { height: 100%; border-radius: 3px; background: var(--lime); transition: width 600ms ease; }
.kr-progress-fill.at-risk { background: var(--warning); }
.kr-progress-fill.behind  { background: var(--danger); }

/* ── SLOs ──────────────────────────── */
.slo-row {
  display: flex; align-items: center; gap: 16px;
  padding: 14px 18px; background: var(--surface);
  border: 1px solid var(--border); border-radius: var(--radius-sm);
  margin-bottom: 8px;
}
.slo-status { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
.slo-name   { flex: 1; font-size: 13px; font-weight: 600; }
.slo-value  { font-size: 15px; font-weight: 700; font-variant-numeric: tabular-nums; min-width: 70px; text-align: right; }
.slo-target-label { font-size: 11px; color: var(--muted); min-width: 80px; text-align: right; }
.slo-budget { font-size: 11px; min-width: 100px; text-align: right; }

/* ── DORA ──────────────────────────── */
.dora-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.dora-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 18px; }
.dora-name  { font-size: 11px; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
.dora-value { font-size: 22px; font-weight: 700; margin-bottom: 8px; font-variant-numeric: tabular-nums; }
.dora-badge { display: inline-block; font-size: 10px; font-weight: 700; padding: 3px 10px; border-radius: 999px; }
.dora-desc  { font-size: 11px; color: var(--muted); margin-top: 6px; }

/* ── Erros e Infra ─────────────────── */
.error-row, .infra-row {
  display: flex; align-items: center; gap: 12px;
  padding: 12px 16px; background: var(--surface);
  border: 1px solid var(--border); border-radius: var(--radius-sm);
  margin-bottom: 8px; font-size: 13px;
}
.error-name  { flex: 1; font-weight: 500; }
.error-count { font-weight: 700; color: var(--danger); font-variant-numeric: tabular-nums; }
.error-trend { font-size: 11px; }
.infra-name  { flex: 1; font-weight: 500; }
.infra-value { font-weight: 600; font-variant-numeric: tabular-nums; }
.infra-status-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }

/* Status colors utility */
.ok      { color: var(--success); }
.warning { color: var(--warning); }
.error   { color: var(--danger); }
.bg-ok   { background: var(--success); }
.bg-warn { background: var(--warning); }
.bg-err  { background: var(--danger); }

/* Responsive */
@media (max-width: 1200px) {
  .kpi-grid { grid-template-columns: repeat(2, 1fr); }
  .dora-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 900px) {
  body { grid-template-columns: 1fr; }
  .sidebar { display: none; }
  .two-col { grid-template-columns: 1fr; }
}
```

---

## assets/data.js

```javascript
// ═══════════════════════════════════════
// DADOS SIMULADOS — substituir por chamadas às APIs reais
// Ver README.md para instruções de integração
// ═══════════════════════════════════════
const dashboardData = {

  meta: {
    product: "[Nome do Produto]",
    lastUpdated: new Date().toLocaleString("pt-BR"),
    period: "30d",
    mode: "simulated" // "simulated" | "live"
  },

  // ── Métricas de Produto ───────────────
  product: {
    mau: { value: 12840, delta: "+18%", trend: "positive" },
    dau: { value: 3210, delta: "+12%", trend: "positive" },
    stickiness: { value: "25%", delta: "+2pp", trend: "positive" },
    activation: { value: "68%", delta: "+5pp", trend: "positive" },
    retention_d30: { value: "42%", delta: "-3pp", trend: "negative" },
    north_star: { value: "8.240", label: "transações/mês", delta: "+22%", trend: "positive" },

    dau_series: {
      labels: ["01/02","05/02","10/02","15/02","20/02","25/02","01/03"],
      dau:    [2100, 2400, 2800, 3000, 2900, 3100, 3210],
      mau:    [9200, 9800, 10400, 11000, 11500, 12200, 12840]
    },

    retention_cohort: {
      labels: ["D1","D7","D14","D30"],
      data:   [85, 62, 51, 42]
    },

    sessions_per_user: {
      labels: ["Jan","Fev","Mar"],
      data:   [4.2, 5.1, 5.8]
    },

    feature_adoption: [
      { name: "Home",         pct: 98, delta: "+0", trend: "neutral" },
      { name: "Extrato",      pct: 82, delta: "+4", trend: "positive" },
      { name: "Pix — Enviar", pct: 71, delta: "+9", trend: "positive" },
      { name: "Cartões",      pct: 54, delta: "+6", trend: "positive" },
      { name: "Pix — Chaves", pct: 38, delta: "+12", trend: "positive" },
      { name: "Pagamentos",   pct: 31, delta: "+2", trend: "positive" },
      { name: "Perfil",       pct: 24, delta: "-1", trend: "neutral" }
    ],

    funnels: [
      {
        name: "Envio de Pix",
        steps: [
          { name: "Acessou Pix",       count: 8240, pct: 100 },
          { name: "Digitou chave",      count: 7010, pct: 85 },
          { name: "Informou valor",     count: 6210, pct: 75 },
          { name: "Confirmou",          count: 5760, pct: 70 },
          { name: "Concluiu",           count: 5540, pct: 67 }
        ]
      },
      {
        name: "Ativação (Onboarding)",
        steps: [
          { name: "Conta criada",       count: 3200, pct: 100 },
          { name: "E-mail verificado",  count: 2880, pct: 90 },
          { name: "Login feito",        count: 2560, pct: 80 },
          { name: "Onboarding visto",   count: 2240, pct: 70 },
          { name: "1ª transação",       count: 2176, pct: 68 }
        ]
      }
    ]
  },

  // ── Outcomes / OKRs ──────────────────
  outcomes: {
    okrs: [
      {
        objective: "[Objetivo do OKR 1 — substituir pelo real da Fase 01]",
        krs: [
          { id: "KR-01", title: "[Descrição do KR]", current: 68, target: 100, unit: "%", status: "on-track" },
          { id: "KR-02", title: "[Descrição do KR]", current: 42, target: 100, unit: "%", status: "at-risk" }
        ]
      }
    ],
    outcomes_series: {
      labels: ["Jan","Fev","Mar"],
      datasets: [
        { label: "KR-01", data: [40, 55, 68] },
        { label: "KR-02", data: [20, 30, 42] }
      ]
    }
  },

  // ── SRE ──────────────────────────────
  sre: {
    system_status: "ok", // "ok" | "degraded" | "down"

    slos: [
      { name: "Disponibilidade API",   value: "99,8%", target: "≥ 99,5%", budget_pct: 76, status: "ok" },
      { name: "Latência p95 (API)",    value: "312ms",  target: "< 500ms",  budget_pct: 100, status: "ok" },
      { name: "Taxa de Erro",          value: "0,12%",  target: "< 0,5%",   budget_pct: 100, status: "ok" },
      { name: "Disponibilidade Auth",  value: "99,97%", target: "≥ 99,9%",  budget_pct: 95, status: "ok" },
      { name: "LCP (Web Vitals)",      value: "1,8s",   target: "< 2,5s",   budget_pct: 100, status: "ok" },
      { name: "CI Build Success Rate", value: "97%",    target: "≥ 95%",    budget_pct: 100, status: "ok" }
    ],

    latency_series: {
      labels: ["01/03","05/03","10/03","15/03","20/03","25/03","01/04"],
      p50:    [98,  102, 95,  110, 105, 98,  101],
      p95:    [280, 310, 295, 420, 380, 312, 308],
      p99:    [520, 580, 490, 890, 720, 610, 590]
    },

    error_series: {
      labels: ["01/03","05/03","10/03","15/03","20/03","25/03","01/04"],
      data:   [0.08, 0.12, 0.09, 0.31, 0.18, 0.12, 0.11]
    },

    dora: {
      deploy_frequency:    { value: "4,2/dia",    badge: "elite",  desc: "Meta: múltiplos/dia" },
      lead_time:           { value: "38min",       badge: "elite",  desc: "Meta: < 1 hora" },
      change_failure_rate: { value: "3,2%",        badge: "elite",  desc: "Meta: < 5%" },
      time_to_restore:     { value: "24min",       badge: "elite",  desc: "Meta: < 1 hora" }
    },

    top_errors: [
      { name: "TypeError: Cannot read properties of undefined",   count: 142, trend: "▼ -18%" },
      { name: "TRPCClientError: UNAUTHORIZED",                    count: 89,  trend: "▲ +5%" },
      { name: "ZodError: Invalid input — pix.create",             count: 34,  trend: "▼ -42%" },
      { name: "NetworkError: Failed to fetch (Upstash timeout)",  count: 12,  trend: "▼ -60%" },
      { name: "AppError: INSUFFICIENT_BALANCE",                   count: 8,   trend: "→ 0%" }
    ],

    infra: [
      { name: "API Vercel",             value: "operacional",  status: "ok" },
      { name: "Banco (Supabase)",       value: "operacional",  status: "ok" },
      { name: "Auth (Supabase)",        value: "operacional",  status: "ok" },
      { name: "Cache (Upstash Redis)",  value: "hit rate 84%", status: "ok" },
      { name: "Fila (QStash)",          value: "operacional",  status: "ok" },
      { name: "CDN (Cloudflare)",       value: "operacional",  status: "ok" }
    ]
  }
};
```

---

## assets/charts.js

```javascript
// ═══════════════════════════════════════
// DASHBOARD — Lógica de Renderização
// ═══════════════════════════════════════

const CHART_DEFAULTS = {
  color: {
    lime:    "#b7ff2a",
    success: "#3dff8b",
    danger:  "#ff4d4d",
    warning: "#ffcc00",
    info:    "#4da3ff",
    muted:   "#7b8aa3",
    grid:    "rgba(28,40,54,0.8)"
  },
  font: { family: "Inter, system-ui, sans-serif", size: 11, color: "#7b8aa3" }
};

Chart.defaults.color = CHART_DEFAULTS.font.color;
Chart.defaults.font.family = CHART_DEFAULTS.font.family;
Chart.defaults.font.size = CHART_DEFAULTS.font.size;

// ── Navegação ─────────────────────────
const SECTION_TITLES = {
  overview: "Visão Geral",
  product:  "Uso do Produto",
  outcomes: "Outcomes & KRs",
  sre:      "SRE & Técnico"
};

function showSection(id) {
  document.querySelectorAll(".content-section").forEach(s => s.classList.remove("active"));
  document.querySelectorAll(".nav-item").forEach(n => n.classList.remove("active"));
  document.getElementById("section-" + id).classList.add("active");
  document.querySelector(`[data-section="${id}"]`).classList.add("active");
  document.getElementById("section-title").textContent = SECTION_TITLES[id];
}

// ── Inicialização ─────────────────────
document.addEventListener("DOMContentLoaded", () => {
  document.getElementById("last-updated").textContent = dashboardData.meta.lastUpdated;
  renderOverview();
  renderProduct();
  renderOutcomes();
  renderSRE();
});

// ── Overview ──────────────────────────
function renderOverview() {
  const p = dashboardData.product;
  const s = dashboardData.sre;

  setKPI("kpi-mau", p.mau.value.toLocaleString("pt-BR"), p.mau.delta, p.mau.trend);
  setKPI("kpi-dau", p.dau.value.toLocaleString("pt-BR"), p.dau.delta, p.dau.trend);
  setKPI("kpi-stickiness", p.stickiness.value, p.stickiness.delta, p.stickiness.trend);
  setKPI("kpi-activation", p.activation.value, p.activation.delta, p.activation.trend);
  setKPI("kpi-retention", p.retention_d30.value, p.retention_d30.delta, p.retention_d30.trend);
  setKPI("kpi-nsm", p.north_star.value, p.north_star.delta, p.north_star.trend);

  // SLO availability bar
  const avail = s.slos[0];
  const availPct = parseFloat(avail.value) - 99;
  document.getElementById("kpi-availability").textContent = avail.value;
  setBar("kpi-availability-bar", avail.budget_pct, avail.status);

  const p95 = s.slos[1];
  document.getElementById("kpi-p95").textContent = p95.value;

  const errRate = s.slos[2];
  document.getElementById("kpi-error-rate").textContent = errRate.value;

  document.getElementById("kpi-error-budget").textContent = avail.budget_pct + "%";
  setBar("kpi-budget-bar", avail.budget_pct, "lime");

  const dora = s.dora;
  document.getElementById("kpi-deploy-freq").textContent = dora.deploy_frequency.value;
  const badge = document.getElementById("kpi-deploy-badge");
  badge.textContent = dora.deploy_frequency.badge.toUpperCase();
  badge.className = "kpi-dora-badge badge-" + dora.deploy_frequency.badge;

  document.getElementById("kpi-lcp").textContent = s.slos[4].value;

  const dot = document.getElementById("system-status");
  dot.className = "status-dot" + (s.system_status !== "ok" ? " " + s.system_status : "");
}

// ── Produto ───────────────────────────
function renderProduct() {
  const p = dashboardData.product;

  // DAU/MAU chart
  new Chart(document.getElementById("chart-dau-mau"), {
    type: "line",
    data: {
      labels: p.dau_series.labels,
      datasets: [
        { label: "DAU", data: p.dau_series.dau, borderColor: CHART_DEFAULTS.color.lime, tension: 0.4, fill: false, pointRadius: 3 },
        { label: "MAU", data: p.dau_series.mau, borderColor: CHART_DEFAULTS.color.info, tension: 0.4, fill: false, pointRadius: 3 }
      ]
    },
    options: chartOptions("", false)
  });

  // Retention chart
  new Chart(document.getElementById("chart-retention"), {
    type: "bar",
    data: {
      labels: p.retention_cohort.labels,
      datasets: [{ label: "Retenção (%)", data: p.retention_cohort.data, backgroundColor: CHART_DEFAULTS.color.lime + "99", borderColor: CHART_DEFAULTS.color.lime, borderWidth: 1 }]
    },
    options: chartOptions("", false)
  });

  // Sessions chart
  new Chart(document.getElementById("chart-sessions"), {
    type: "line",
    data: {
      labels: p.sessions_per_user.labels,
      datasets: [{ label: "Sessões/Usuário", data: p.sessions_per_user.data, borderColor: CHART_DEFAULTS.color.success, tension: 0.4, fill: true, backgroundColor: CHART_DEFAULTS.color.success + "18" }]
    },
    options: chartOptions("", false)
  });

  // Feature adoption
  const list = document.getElementById("feature-adoption-list");
  p.feature_adoption.forEach(f => {
    const trendColor = f.trend === "positive" ? "ok" : f.trend === "negative" ? "error" : "neutral";
    const trendIcon  = f.trend === "positive" ? "▲" : f.trend === "negative" ? "▼" : "→";
    list.innerHTML += `
      <div class="feature-row">
        <div class="feature-name">${f.name}</div>
        <div class="feature-bar-wrap"><div class="feature-bar" style="width:${f.pct}%"></div></div>
        <div class="feature-pct">${f.pct}%</div>
        <div class="feature-trend ${trendColor}">${trendIcon} ${f.delta}pp</div>
      </div>`;
  });

  // Funnels
  const funnelGrid = document.getElementById("funnel-grid");
  p.funnels.forEach(f => {
    const total = f.steps[0].count;
    const stepsHTML = f.steps.map((s, i) => {
      const drop = i > 0 ? `<span class="funnel-drop"> (-${(f.steps[i-1].pct - s.pct).toFixed(0)}pp)</span>` : "";
      return `<div class="funnel-step">
        <div class="funnel-step-name">${s.name}</div>
        <div class="funnel-step-count">${s.count.toLocaleString("pt-BR")}</div>
        <div class="funnel-step-pct">${s.pct}%${drop}</div>
      </div>`;
    }).join("");
    funnelGrid.innerHTML += `<div class="funnel-card"><div class="funnel-title">${f.name}</div>${stepsHTML}</div>`;
  });
}

// ── Outcomes ──────────────────────────
function renderOutcomes() {
  const o = dashboardData.outcomes;
  const okrList = document.getElementById("okr-list");
  o.okrs.forEach(okr => {
    const krsHTML = okr.krs.map(kr => {
      const barClass = kr.status === "at-risk" ? "at-risk" : kr.status === "behind" ? "behind" : "";
      return `<div class="kr-item">
        <div class="kr-title">${kr.id} — ${kr.title}</div>
        <div class="kr-meta">
          <span>${kr.current}${kr.unit} de ${kr.target}${kr.unit}</span>
          <span class="${kr.status === 'on-track' ? 'ok' : 'warning'}">${kr.status === 'on-track' ? '✓ No prazo' : '⚠ Em risco'}</span>
        </div>
        <div class="kr-progress-wrap"><div class="kr-progress-fill ${barClass}" style="width:${kr.current}%"></div></div>
      </div>`;
    }).join("");
    okrList.innerHTML += `<div class="okr-card">
      <div class="okr-header"><div class="okr-objective">${okr.objective}</div></div>
      <div class="kr-list">${krsHTML}</div>
    </div>`;
  });

  new Chart(document.getElementById("chart-outcomes"), {
    type: "line",
    data: {
      labels: o.outcomes_series.labels,
      datasets: o.outcomes_series.datasets.map((d, i) => ({
        ...d,
        borderColor: [CHART_DEFAULTS.color.lime, CHART_DEFAULTS.color.info][i % 2],
        tension: 0.4, fill: false, pointRadius: 3
      }))
    },
    options: chartOptions("% de progresso", false)
  });
}

// ── SRE ───────────────────────────────
function renderSRE() {
  const s = dashboardData.sre;

  // SLOs
  const sloList = document.getElementById("slo-list");
  s.slos.forEach(slo => {
    const dotClass = slo.status === "ok" ? "bg-ok" : slo.status === "warning" ? "bg-warn" : "bg-err";
    const valueClass = slo.status === "ok" ? "ok" : slo.status === "warning" ? "warning" : "error";
    const budget = slo.budget_pct < 25 ? "error" : slo.budget_pct < 50 ? "warning" : "ok";
    sloList.innerHTML += `<div class="slo-row">
      <div class="slo-status ${dotClass}"></div>
      <div class="slo-name">${slo.name}</div>
      <div class="slo-value ${valueClass}">${slo.value}</div>
      <div class="slo-target-label">${slo.target}</div>
      <div class="slo-budget ${budget}">Budget: ${slo.budget_pct}%</div>
    </div>`;
  });

  // Latency chart
  const ls = s.latency_series;
  new Chart(document.getElementById("chart-latency"), {
    type: "line",
    data: {
      labels: ls.labels,
      datasets: [
        { label: "p50", data: ls.p50, borderColor: CHART_DEFAULTS.color.success, tension: 0.4, fill: false, pointRadius: 2 },
        { label: "p95", data: ls.p95, borderColor: CHART_DEFAULTS.color.lime, tension: 0.4, fill: false, pointRadius: 2 },
        { label: "p99", data: ls.p99, borderColor: CHART_DEFAULTS.color.danger, tension: 0.4, fill: false, pointRadius: 2 }
      ]
    },
    options: chartOptions("ms", false)
  });

  // Error rate chart
  const es = s.error_series;
  new Chart(document.getElementById("chart-errors"), {
    type: "line",
    data: {
      labels: es.labels,
      datasets: [{
        label: "Taxa de Erro (%)", data: es.data,
        borderColor: CHART_DEFAULTS.color.danger,
        backgroundColor: CHART_DEFAULTS.color.danger + "18",
        tension: 0.4, fill: true, pointRadius: 2
      }]
    },
    options: chartOptions("%", false)
  });

  // DORA
  const doraGrid = document.getElementById("dora-grid");
  const doraLabels = {
    deploy_frequency:    "Deploy Frequency",
    lead_time:           "Lead Time",
    change_failure_rate: "Change Failure Rate",
    time_to_restore:     "Time to Restore"
  };
  Object.entries(s.dora).forEach(([key, d]) => {
    doraGrid.innerHTML += `<div class="dora-card">
      <div class="dora-name">${doraLabels[key]}</div>
      <div class="dora-value">${d.value}</div>
      <span class="dora-badge badge-${d.badge}">${d.badge.toUpperCase()}</span>
      <div class="dora-desc">${d.desc}</div>
    </div>`;
  });

  // Top errors
  const errorList = document.getElementById("error-list");
  s.top_errors.forEach(e => {
    const trendClass = e.trend.startsWith("▼") ? "ok" : e.trend.startsWith("▲") ? "error" : "muted";
    errorList.innerHTML += `<div class="error-row">
      <div class="error-name">${e.name}</div>
      <div class="error-count">${e.count.toLocaleString("pt-BR")}</div>
      <div class="error-trend ${trendClass}">${e.trend}</div>
    </div>`;
  });

  // Infra
  const infraList = document.getElementById("infra-list");
  s.infra.forEach(i => {
    const dotClass = i.status === "ok" ? "bg-ok" : i.status === "warning" ? "bg-warn" : "bg-err";
    const valClass  = i.status === "ok" ? "ok" : i.status === "warning" ? "warning" : "error";
    infraList.innerHTML += `<div class="infra-row">
      <div class="infra-status-dot ${dotClass}"></div>
      <div class="infra-name">${i.name}</div>
      <div class="infra-value ${valClass}">${i.value}</div>
    </div>`;
  });
}

// ── Helpers ───────────────────────────
function setKPI(id, value, delta, trend) {
  document.getElementById(id).textContent = value;
  const el = document.getElementById(id + "-delta");
  if (!el) return;
  el.textContent = delta;
  el.className = "kpi-delta " + (trend === "positive" ? "positive" : trend === "negative" ? "negative" : "neutral");
}

function setBar(id, pct, type) {
  const el = document.getElementById(id);
  if (!el) return;
  el.style.width = pct + "%";
  el.className = "kpi-bar" + (type === "lime" ? " lime" : pct > 50 ? " ok" : pct > 25 ? "" : "");
}

function chartOptions(yLabel, legend) {
  return {
    responsive: true, maintainAspectRatio: true,
    plugins: { legend: { display: legend !== false, labels: { boxWidth: 10, padding: 12 } } },
    scales: {
      x: { grid: { color: CHART_DEFAULTS.color.grid }, ticks: { maxRotation: 0 } },
      y: { grid: { color: CHART_DEFAULTS.color.grid }, title: { display: !!yLabel, text: yLabel } }
    }
  };
}

function updatePeriod(val) {
  // Hook para atualizar dados quando o período muda
  // Em modo live: refetch das APIs com o novo período
  console.log("Período selecionado:", val);
}
```

---

## README.md (instruções de integração)

```markdown
# Dashboard Operacional — Guia de Integração

## Modo Atual: Dados Simulados
O dashboard está rodando com dados simulados em `assets/data.js`.
Para conectar às fontes reais, siga as instruções abaixo por seção.

## Integrações por Fonte

### PostHog (Métricas de Produto)
1. Acesse PostHog → Settings → Personal API Keys → Create Key
2. Use a API: `https://app.posthog.com/api/projects/{project_id}/insights/`
3. Substitua os valores em `data.js` → seção `product` com as respostas da API

### New Relic (Latência e Throughput)
1. Acesse New Relic → API Keys → Create Key (tipo: User)
2. Use NRQL via API: `https://api.newrelic.com/graphql`
3. Query de exemplo para p95: `SELECT percentile(duration, 95) FROM Transaction TIMESERIES`

### Sentry (Erros)
1. Acesse Sentry → Settings → API → Auth Tokens → Create Token
2. Use a API: `https://sentry.io/api/0/projects/{org}/{project}/issues/`

### Supabase (Banco de Dados)
Métricas disponíveis no painel: Settings → Database → Reports

### GitHub Actions (DORA)
Use a GitHub API: `GET /repos/{owner}/{repo}/actions/runs`
Lead time: comparar `created_at` do run com o `committed_date` do commit.
```

---

## Checklist de Qualidade do Dashboard
- [ ] Abre via `file://` sem erros no console
- [ ] Todas as 4 seções navegáveis pela sidebar
- [ ] Item ativo destacado em lime
- [ ] Gráficos renderizando com dados simulados
- [ ] Barras de progresso SLO e KR animadas
- [ ] DORA badges com cores corretas por nível
- [ ] Identidade o produto (conforme design_spec.md) fiel (dark + lime)
- [ ] Responsivo em telas < 900px
- [ ] `data.js` com comentários indicando onde substituir dados reais
- [ ] `README.md` com instruções de integração por fonte
