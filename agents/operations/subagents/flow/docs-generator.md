# Skill: docs-generator

## Objetivo
Gerar um site de documentação estático com todos os artefatos produzidos nas 4 fases do ciclo de produto.
Executado pelo Orquestrador como **última etapa após HITL #12**.

## Localização do Output
```
{REPO_DESTINO}/docs/
├── index.html              # Home — visão geral do produto e ciclo
├── fase-01.html            # Contexto Estratégico
├── fase-02.html            # Product Discovery
├── fase-03.html            # Product Delivery
├── fase-04.html            # Operação e A/B Testing
├── assets/
│   ├── style.css           # Identidade o produto (conforme design_spec.md) aplicada ao docs
│   └── nav.js              # Navegação e interatividade
└── README.md               # Instruções de uso do docs
```

## Identidade Visual do Site de Docs
Seguir a identidade o produto (conforme design_spec.md): `{REPO_DESTINO}/design_spec.md`
- Tema: Dark + Verde-limão
- Background: `#0b0f14`
- Surface: `#131c28`
- Lime: `#b7ff2a` (destaques, links ativos, badges)
- Fonte: Inter

## Estrutura do Site

### index.html — Home
- Header com logo o produto (conforme design_spec.md) + nome do produto
- Resumo do produto (visão, North Star Metric)
- Timeline visual das 4 fases com status de cada HITL
- Links para cada fase
- Rodapé com data de geração e versão do squad

### fase-01.html — Contexto Estratégico
Artefatos incluídos:
- Objetivo e Key Results (OKRs) com baselines e targets
- OST (Opportunity Solution Tree) — oportunidades mapeadas
- Visão do produto e North Star Metric
- Princípios de produto

### fase-02.html — Product Discovery
Artefatos incluídos:
- Oportunidades priorizadas (com score e evidências)
- Hipóteses testadas e resultados
- Protótipos (links para os arquivos HTML gerados)
- Épicos e suas hipóteses de benefício
- Features por épico
- Histórias de usuário com critérios de aceitação (Gherkin)
- Resultado da avaliação dos 4 riscos (Cagan)

### fase-03.html — Product Delivery
Artefatos incluídos:
- Modelo de domínio (bounded contexts, linguagem ubíqua)
- ADRs (Architecture Decision Records)
- Contratos tRPC (API)
- Schema do banco (Drizzle)
- Relatório de qualidade (cobertura Vitest, resultados Playwright)
- Stack tecnológica utilizada

### fase-04.html — Operação e A/B Testing
Artefatos incluídos:
- SLOs definidos e status atual
- Configuração de feature flags e experimentos A/B
- Métricas DORA (deployment frequency, lead time, etc.)
- Resultados dos testes A/B e aprendizados
- Retroalimentação para o próximo ciclo

## Template HTML Base

```html
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{Título da Página} — o produto (conforme design_spec.md) Docs</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <!-- Sidebar de navegação -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <span class="logo-mark">⬡</span>
      <span class="logo-text">o produto (conforme design_spec.md) <span class="logo-tag">docs</span></span>
    </div>
    <nav class="sidebar-nav">
      <a href="index.html" class="nav-item">🏠 Visão Geral</a>
      <a href="fase-01.html" class="nav-item">📋 Fase 01 — Estratégia</a>
      <a href="fase-02.html" class="nav-item">🔍 Fase 02 — Discovery</a>
      <a href="fase-03.html" class="nav-item">🔧 Fase 03 — Delivery</a>
      <a href="fase-04.html" class="nav-item">⚙️ Fase 04 — Operação</a>
    </nav>
  </aside>

  <!-- Conteúdo principal -->
  <main class="main">
    <header class="topbar">
      <h1 class="page-title">{Título}</h1>
      <span class="badge">{HITL Status}</span>
    </header>
    <div class="content">
      <!-- Artefatos da fase -->
    </div>
  </main>

  <script src="assets/nav.js"></script>
</body>
</html>
```

## assets/style.css (base)

```css
/* o produto (conforme design_spec.md) Docs — Dark + Lime */
:root {
  --bg: #0b0f14;
  --surface: #131c28;
  --surface-2: #0f1620;
  --border: #1c2836;
  --text: #eaf2ff;
  --text-2: #a9b7cc;
  --muted: #7b8aa3;
  --lime: #b7ff2a;
  --lime-dim: rgba(183,255,42,0.12);
  --success: #3dff8b;
  --danger: #ff4d4d;
  --info: #4da3ff;
  --sidebar-w: 260px;
  --topbar-h: 60px;
  --font: Inter, system-ui, sans-serif;
  --radius: 12px;
}

* { box-sizing: border-box; margin: 0; padding: 0; }
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

/* Sidebar */
.sidebar {
  position: sticky; top: 0; height: 100vh;
  background: var(--surface);
  border-right: 1px solid var(--border);
  padding: 24px 16px;
  display: flex; flex-direction: column; gap: 32px;
  overflow-y: auto;
}
.sidebar-logo { display: flex; align-items: center; gap: 10px; padding: 0 8px; }
.logo-mark { font-size: 22px; color: var(--lime); }
.logo-text { font-weight: 700; font-size: 15px; letter-spacing: 0.2px; }
.logo-tag {
  font-size: 10px; font-weight: 600; color: var(--lime);
  background: var(--lime-dim); border-radius: 4px; padding: 1px 6px; margin-left: 4px;
}
.sidebar-nav { display: flex; flex-direction: column; gap: 2px; }
.nav-item {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 12px; border-radius: 8px;
  font-size: 13px; font-weight: 500; color: var(--text-2);
  text-decoration: none; transition: all 140ms ease;
}
.nav-item:hover { background: var(--surface-2); color: var(--text); }
.nav-item.active {
  background: var(--lime-dim); color: var(--lime);
  border-left: 3px solid var(--lime); padding-left: 9px;
}

/* Main */
.main { display: flex; flex-direction: column; min-height: 100vh; overflow-x: hidden; }
.topbar {
  position: sticky; top: 0;
  height: var(--topbar-h);
  background: rgba(11,15,20,0.80); backdrop-filter: blur(10px);
  border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 32px; z-index: 10;
}
.page-title { font-size: 16px; font-weight: 600; }
.content { padding: 32px; max-width: 900px; }

/* Artefatos */
.section { margin-bottom: 40px; }
.section-title {
  font-size: 18px; font-weight: 700; color: var(--text);
  margin-bottom: 16px; padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

/* Cards de artefatos */
.artifact-card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 20px; margin-bottom: 12px;
}
.artifact-label {
  font-size: 11px; font-weight: 600; letter-spacing: 0.8px;
  text-transform: uppercase; color: var(--muted); margin-bottom: 8px;
}
.artifact-title { font-size: 15px; font-weight: 600; margin-bottom: 6px; }
.artifact-body { font-size: 13px; color: var(--text-2); line-height: 1.6; }

/* Badges de status */
.badge {
  font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 999px;
}
.badge-approved { background: rgba(61,255,139,0.12); color: var(--success); }
.badge-pending  { background: rgba(255,204,0,0.12);  color: var(--warning, #ffcc00); }
.badge-rejected { background: rgba(255,77,77,0.12);  color: var(--danger); }

/* Epics / Features / Stories */
.epic { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-bottom: 16px; overflow: hidden; }
.epic-header { background: var(--lime-dim); border-bottom: 1px solid var(--border); padding: 14px 20px; display: flex; gap: 12px; align-items: center; }
.epic-id { font-size: 11px; font-weight: 700; color: var(--lime); }
.epic-title { font-size: 14px; font-weight: 600; }
.features { padding: 12px 20px; display: flex; flex-direction: column; gap: 8px; }
.feature { padding: 10px 14px; background: var(--surface-2); border-radius: 8px; font-size: 13px; }
.stories { padding: 0 20px 12px; display: flex; flex-direction: column; gap: 6px; }
.story { padding: 8px 12px; border-left: 2px solid var(--border); font-size: 13px; color: var(--text-2); }

/* KRs */
.kr-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px 20px; margin-bottom: 12px; }
.kr-metric { font-size: 13px; color: var(--muted); margin-bottom: 8px; }
.kr-progress { height: 4px; background: var(--surface-2); border-radius: 2px; margin-top: 10px; }
.kr-progress-fill { height: 100%; background: var(--lime); border-radius: 2px; }

/* ADR */
.adr { border-left: 3px solid var(--info); padding-left: 16px; margin-bottom: 16px; }
.adr-number { font-size: 11px; color: var(--info); font-weight: 700; margin-bottom: 4px; }
.adr-title { font-size: 14px; font-weight: 600; margin-bottom: 6px; }
.adr-body { font-size: 13px; color: var(--text-2); line-height: 1.6; }

/* Risco */
.risk-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.risk-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; }
.risk-name { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px; color: var(--muted); margin-bottom: 8px; }
.risk-verdict { font-size: 14px; font-weight: 600; }
.risk-approved { color: var(--success); }
.risk-rejected { color: var(--danger); }

/* Responsivo */
@media (max-width: 768px) {
  body { grid-template-columns: 1fr; }
  .sidebar { display: none; }
  .content { padding: 20px; }
}
```

## assets/nav.js (base)

```javascript
// Marcar item ativo na sidebar
document.querySelectorAll(".nav-item").forEach(link => {
  if (link.href === window.location.href) {
    link.classList.add("active");
  }
});
```

## Instrução de Geração

### Princípio Central
**Documentar TUDO que foi gerado — não seguir uma lista fixa.**
O agente deve varrer recursivamente todas as pastas de output do produto e incluir cada artefato encontrado, independentemente de ter sido antecipado ou não. Nenhum arquivo gerado pelos agentes pode ficar de fora.

### Passo a Passo

Ao final da Fase 04 (após HITL #12 aprovado), o Orquestrador instrui o Operations Agent a:

1. **Varrer** recursivamente todo o conteúdo de `{REPO_DESTINO}/` — pastas `01`, `02`, `03`, `04` e qualquer subpasta
2. **Catalogar** cada arquivo encontrado: tipo, fase de origem, nome, conteúdo
3. **Criar** a pasta `{REPO_DESTINO}/docs/`
4. **Gerar** `assets/style.css` e `assets/nav.js` conforme templates acima
5. **Gerar** `index.html` com visão geral, timeline e índice completo de artefatos
6. **Gerar** `fase-01.html` incluindo **todos** os arquivos encontrados em `01-strategic-context/`
7. **Gerar** `fase-02.html` incluindo **todos** os arquivos encontrados em `02-product-discovery/` e subpastas
8. **Gerar** `fase-03.html` incluindo **todos** os arquivos encontrados em `03-product-delivery/` e subpastas
9. **Gerar** `fase-04.html` incluindo **todos** os arquivos encontrados em `04-product-operation/` e subpastas
10. **Verificar** que o site abre via `file://` sem erros e que nenhum artefato ficou de fora
11. **Commitar** a pasta `docs/` no repositório do produto

### Regra de Apresentação por Tipo de Artefato

| Extensão / Tipo | Como apresentar no site |
|----------------|------------------------|
| `.json` (OKRs, OST, hipóteses, histórias) | Renderizar campos como cards estruturados com labels legíveis |
| `.md` (ADRs, briefs, postmortems, relatórios) | Renderizar como texto formatado com títulos e parágrafos |
| `.html` (protótipos) | Link de abertura em nova aba + thumbnail descritivo |
| `.ts` / `.sql` (schemas, migrations) | Bloco de código com syntax highlight simples |
| Qualquer outro | Incluir com descrição do nome do arquivo e link de download |

### Artefatos Esperados por Fase (lista orientativa — não exaustiva)

**Fase 01 — Contexto Estratégico**
OKRs, OST, visão do produto, North Star Metric, princípios de produto, opportunity briefs, roadmap de outcomes, assumption map, análise de mercado, segmentação de clientes

**Fase 02 — Product Discovery**
Oportunidades priorizadas, hipóteses testadas, resumo de entrevistas, insights de pesquisa, protótipos low-fi e high-fi, épicos, features, histórias de usuário com critérios de aceitação (Gherkin), avaliação dos 4 riscos, backlog priorizado

**Fase 03 — Product Delivery**
Modelo de domínio, bounded contexts, linguagem ubíqua, ADRs, contratos tRPC, schema Drizzle, tech radar, relatório de qualidade (cobertura Vitest + resultados Playwright), relatório de acessibilidade, documentação de API, logs de decisão

**Fase 04 — Operação**
SLOs e error budgets, configuração de feature flags, resultados de experimentos A/B, métricas DORA, postmortems, relatórios de retroalimentação, recomendações para o próximo ciclo

## Checklist de Qualidade do Site
- [ ] Abre localmente via `file://` sem erros
- [ ] Navegação lateral funciona em todas as páginas
- [ ] Item ativo destacado em lime na sidebar
- [ ] Todos os artefatos das 4 fases presentes
- [ ] Épicos → Features → Histórias com hierarquia visual clara
- [ ] OKRs com métricas e targets legíveis
- [ ] ADRs numerados e com decisão clara
- [ ] Badges de status dos HITLs visíveis
- [ ] Responsivo (legível no mobile)
- [ ] Identidade o produto (conforme design_spec.md) fiel (dark + lime)

---

## Guia de Instalação
Gerar também o arquivo `docs/INSTALACAO.md` e a página `docs/instalacao.html` via skill `installation-guide-writer`.

Adicionar link para o guia de instalação no `index.html` do site de documentação, no menu lateral e na seção de próximos passos.

---

## Diagrama de Classes na Documentação (fase-03.html)

Incluir o diagrama Mermaid de classes no site de documentação com o tema dark o produto (conforme design_spec.md):

```html
<!-- No <head> do fase-03.html -->
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({
    startOnLoad: true,
    theme: "dark",
    themeVariables: {
      background: "#0b0f14",
      primaryColor: "#131c28",
      primaryTextColor: "#eaf2ff",
      primaryBorderColor: "#27364a",
      lineColor: "#b7ff2a",
      fontFamily: "Inter, system-ui, sans-serif"
    }
  });
</script>

<!-- No conteúdo da seção de Arquitetura -->
<div class="section">
  <h2 class="section-title">Modelo de Classes</h2>
  <div class="mermaid">
    [conteúdo do arquivo class-diagram.mermaid]
  </div>
</div>
```
