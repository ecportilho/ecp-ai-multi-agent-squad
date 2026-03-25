---
name: low-fi-prototyper
description: >
  Criar protótipo wireframe HTML navegável de baixa fidelidade para validação de conceito e fluxo. Use na Fase 02 após aprovação das hipóteses de ideação — produz o low-fi.html e o mapa de fluxo.
---

# Skill: low-fi-prototyper

## Objetivo
Criar protótipo wireframe de baixa fidelidade em **arquivo HTML único** para validação de conceito.
Mitiga: **Risco de Valor para o Cliente** — o usuário quer isso? Resolve o problema dele?

## O que este protótipo NÃO é
- NÃO é bonito — é um wireframe funcional
- NÃO aplica identidade visual — sem cores do `design_spec.md`, sem tema dark/light
- NÃO valida usabilidade — isso é papel do high-fi
- NÃO tem micro-interações ou animações

## O que este protótipo É
- Um wireframe navegável que permite ao usuário percorrer todos os fluxos do produto
- Uma ferramenta para responder: "Isso resolve meu problema?"
- Um mapa vivo da estrutura de informação e dos caminhos do produto

## Input
```json
{
  "oportunidades_priorizadas": [],
  "ost_aprovada": {},
  "product_briefing_spec": "{REPO_DESTINO}/product_briefing_spec.md"
}
```

## Output
- **Arquivo único:** `{REPO_DESTINO}/02-product-discovery/prototype/low-fi.html`
- Abre direto no browser via `file://`, sem servidor

## Estilo Visual — Wireframe Neutro

```css
/* OBRIGATÓRIO — Visual wireframe padrão */
:root {
  --wireframe-bg: #f5f5f5;
  --wireframe-surface: #ffffff;
  --wireframe-border: #cccccc;
  --wireframe-text: #333333;
  --wireframe-text-secondary: #888888;
  --wireframe-cta: #555555;
  --wireframe-cta-text: #ffffff;
  --wireframe-radius: 8px;
  --wireframe-font: system-ui, -apple-system, sans-serif;
}

body {
  font-family: var(--wireframe-font);
  background: var(--wireframe-bg);
  color: var(--wireframe-text);
  margin: 0;
  padding: 0;
}

/* Estilo wireframe — sem cores de marca */
.card {
  background: var(--wireframe-surface);
  border: 2px solid var(--wireframe-border);
  border-radius: var(--wireframe-radius);
  padding: 16px;
}

.btn {
  background: var(--wireframe-cta);
  color: var(--wireframe-cta-text);
  border: none;
  border-radius: var(--wireframe-radius);
  padding: 12px 24px;
  cursor: pointer;
  font-size: 14px;
}

.btn-outline {
  background: transparent;
  color: var(--wireframe-cta);
  border: 2px solid var(--wireframe-cta);
}

/* Placeholder para imagens/ícones */
.placeholder {
  background: #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  font-size: 12px;
}
```

## Regra Central de Navegação — OBRIGATÓRIO

O protótipo low-fi **DEVE ser navegável de ponta a ponta**.

### Implementação (arquivo HTML único)
Todas as telas coexistem no DOM — apenas uma visível por vez:

```javascript
// Sistema de navegação entre telas
let currentScreen = 'screen-home';
const history = [];

function navigateTo(screenId) {
  history.push(currentScreen);
  document.getElementById(currentScreen).style.display = 'none';
  document.getElementById(screenId).style.display = 'flex';
  currentScreen = screenId;
  window.scrollTo(0, 0);
}

function goBack() {
  if (history.length > 0) {
    document.getElementById(currentScreen).style.display = 'none';
    currentScreen = history.pop();
    document.getElementById(currentScreen).style.display = 'flex';
    window.scrollTo(0, 0);
  }
}
```

```css
.screen { display: none; flex-direction: column; min-height: 100vh; }
.screen.active { display: flex; }
```

```html
<!-- Estrutura base -->
<div class="screen active" id="screen-home">
  <header>[Logo placeholder] [Nome do Produto]</header>
  <main>
    <!-- Conteúdo wireframe -->
    <button class="btn" onclick="navigateTo('screen-fluxo-1')">Ação principal</button>
  </main>
  <nav><!-- Navegação inferior ou lateral --></nav>
</div>

<div class="screen" id="screen-fluxo-1">
  <header>
    <button onclick="goBack()">← Voltar</button>
    <span>Título da tela</span>
  </header>
  <main><!-- Wireframe do fluxo --></main>
</div>
```

## Entregável Obrigatório: Mapa de Fluxo

O mapa de fluxo deve estar **embutido no próprio HTML** como um comentário no topo do arquivo:

```html
<!--
MAPA DE FLUXO — [Nome do Produto]

TELAS:
- screen-login → Autenticação
- screen-home → Visão geral
- screen-fluxo-1 → [descrição]
- screen-fluxo-1-confirm → [descrição]
- screen-fluxo-1-success → [descrição]

TRANSIÇÕES:
- screen-login → [Entrar] → screen-home
- screen-home → [CTA principal] → screen-fluxo-1
- screen-fluxo-1 → [Continuar] → screen-fluxo-1-confirm
- screen-fluxo-1 → [Cancelar/Voltar] → screen-home
- screen-fluxo-1-confirm → [Confirmar] → screen-fluxo-1-success
- screen-fluxo-1-success → [Início] → screen-home

ESTADOS:
- screen-fluxo-1: erro de validação (inline)
- screen-fluxo-1-confirm: bloqueio (saldo insuficiente etc.)
- screen-fluxo-1-success: sucesso / falha
-->
```

## Critérios de Qualidade
- [ ] **Arquivo HTML único** — tudo inline (CSS + JS + HTML)
- [ ] **Visual wireframe neutro** — sem cores de marca, sem identidade visual
- [ ] **Todos os fluxos priorizados navegáveis** de ponta a ponta
- [ ] **Nenhum botão morto** — todo elemento interativo funciona
- [ ] **Botão voltar** disponível em todas as telas internas
- [ ] **Dados fictícios realistas** — valores, nomes, datas preenchidos
- [ ] **Estados de tela** — vazio, carregado, erro, sucesso
- [ ] **Mapa de fluxo embutido** como comentário HTML no topo
- [ ] **Funciona via file://** — sem servidor
- [ ] **Hierarquia de informação** clara em cada tela
- [ ] **Foco em valor** — o protótipo responde "isso resolve meu problema?"

## Output JSON
```json
{
  "agent": "product-designer",
  "skill": "low-fi-prototyper",
  "output": "{REPO_DESTINO}/02-product-discovery/prototype/low-fi.html",
  "format": "single-html-wireframe",
  "risk_mitigated": "customer_value",
  "flows_covered": [],
  "screens_count": 0,
  "feedback_needed": []
}
```
