# Skill: high-fi-prototyper

## Objetivo
Criar protótipo interativo de alta fidelidade em **arquivo HTML único** (CSS + JS inline).
Deve ser 100% funcional, navegável e representar fielmente a aplicação final.
Mitiga: **Risco de Usabilidade** + **Risco de Valor para o Cliente**.

## Inputs Obrigatórios
Ler ANTES de escrever qualquer HTML:
1. **`{REPO_DESTINO}/design_spec.md`** — identidade visual completa (paleta, tipografia, tokens, componentes)
2. **`{REPO_DESTINO}/02-product-discovery/prototype/low-fi.html`** — mapa de fluxo aprovado (comentário HTML no topo)
3. **Feedback do HITL #4** (low-fi) — ajustes solicitados pelo humano

## Output
- **Arquivo único:** `{REPO_DESTINO}/02-product-discovery/prototype/high-fi.html`
- Abre direto no browser via `file://`, sem servidor
- **TUDO inline** — CSS no `<style>`, JS no `<script>`, sem arquivos externos (exceto CDN de fontes)

## Regra Central — Identidade Visual do design_spec.md

> **NUNCA inventar cores, fontes ou tokens. TUDO vem do `design_spec.md`.**

### Como extrair a identidade do design_spec.md

1. Ler o arquivo `{REPO_DESTINO}/design_spec.md` completamente
2. Extrair a **paleta de cores** e mapear para CSS custom properties:
   ```css
   :root {
     /* Mapear CADA cor do design_spec.md para uma variável */
     --color-bg-primary: /* valor do design_spec.md */;
     --color-bg-secondary: /* valor do design_spec.md */;
     --color-bg-elevated: /* valor do design_spec.md */;
     --color-border-default: /* valor do design_spec.md */;
     --color-text-primary: /* valor do design_spec.md */;
     --color-text-secondary: /* valor do design_spec.md */;
     --color-text-muted: /* valor do design_spec.md */;
     --color-brand-primary: /* valor do design_spec.md */;
     --color-brand-hover: /* valor do design_spec.md */;
     --color-brand-active: /* valor do design_spec.md */;
     --color-success: /* valor do design_spec.md */;
     --color-danger: /* valor do design_spec.md */;
     --color-warning: /* valor do design_spec.md */;
     --color-info: /* valor do design_spec.md */;
     /* ... todas as cores documentadas */
   }
   ```
3. Extrair **tipografia** (fontes, pesos, tamanhos) e importar via Google Fonts CDN
4. Extrair **espaçamento e border-radius**
5. Extrair **especificações de componentes** (botões, cards, inputs, nav)
6. Aplicar a **regra de ouro** documentada (ex: "Lime apenas para CTAs")

### Se o design_spec.md definir tokens CSS prontos
Copiar os tokens diretamente para o `<style>` do protótipo — não reinterpretar.

### Se o design_spec.md definir apenas valores soltos
Montar o `:root` com as variáveis CSS a partir dos valores documentados.

## Estrutura do Arquivo HTML Único

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>[Nome do Produto] — Protótipo High-Fi</title>

  <!-- Fonte do design_spec.md (via CDN) -->
  <link href="https://fonts.googleapis.com/css2?family=[FONTE_DO_DESIGN_SPEC]:wght@400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* ═══════════════════════════════════════════════════════════
       TOKENS — Extraídos de {REPO_DESTINO}/design_spec.md
       ═══════════════════════════════════════════════════════════ */
    :root {
      /* Colar TODOS os tokens do design_spec.md aqui */
    }

    /* ═══════════════════════════════════════════════════════════
       RESET + BASE
       ═══════════════════════════════════════════════════════════ */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: var(--font-family, system-ui);
      background: var(--color-bg-primary);
      color: var(--color-text-primary);
      min-height: 100vh;
    }

    /* ═══════════════════════════════════════════════════════════
       SISTEMA DE TELAS
       ═══════════════════════════════════════════════════════════ */
    .screen { display: none; flex-direction: column; min-height: 100vh; }
    .screen.active { display: flex; }

    /* ═══════════════════════════════════════════════════════════
       COMPONENTES — Conforme design_spec.md
       ═══════════════════════════════════════════════════════════ */
    /* Botões, cards, inputs, nav, modais, sheets, etc. */

    /* ═══════════════════════════════════════════════════════════
       LAYOUT — Shell da aplicação
       ═══════════════════════════════════════════════════════════ */
    /* Sidebar/topbar (web) ou bottom nav (mobile) */

    /* ═══════════════════════════════════════════════════════════
       ANIMAÇÕES E TRANSIÇÕES
       ═══════════════════════════════════════════════════════════ */
    /* Transições entre telas, hover, focus */
  </style>
</head>
<body>

  <!--
  ═══════════════════════════════════════════════════════════════
  MAPA DE FLUXO (copiado do low-fi aprovado + ajustes do HITL #4)

  TELAS: [listar todas]
  TRANSIÇÕES: [listar todas]
  ESTADOS: [listar todos]
  ═══════════════════════════════════════════════════════════════
  -->

  <!-- Tela: Login -->
  <div class="screen active" id="screen-login">
    <!-- Implementar com tokens do design_spec.md -->
  </div>

  <!-- Tela: Home/Dashboard -->
  <div class="screen" id="screen-home">
    <!-- Shell completa: sidebar/topbar ou bottom nav -->
    <!-- Conteúdo com dados mockados realistas -->
  </div>

  <!-- ... demais telas conforme mapa de fluxo ... -->

  <script>
    /* ═══════════════════════════════════════════════════════════
       NAVEGAÇÃO
       ═══════════════════════════════════════════════════════════ */
    let currentScreen = 'screen-login';
    const navHistory = [];

    function navigateTo(screenId) {
      navHistory.push(currentScreen);
      const current = document.getElementById(currentScreen);
      const next = document.getElementById(screenId);
      if (current) current.classList.remove('active');
      if (next) next.classList.add('active');
      currentScreen = screenId;
      window.scrollTo(0, 0);
      updateNav(screenId);
    }

    function goBack() {
      if (navHistory.length > 0) {
        const prev = navHistory.pop();
        const current = document.getElementById(currentScreen);
        const next = document.getElementById(prev);
        if (current) current.classList.remove('active');
        if (next) next.classList.add('active');
        currentScreen = prev;
        window.scrollTo(0, 0);
        updateNav(prev);
      }
    }

    function updateNav(screenId) {
      document.querySelectorAll('[data-nav]').forEach(item => {
        item.classList.toggle('active', item.dataset.nav === screenId);
      });
    }

    /* ═══════════════════════════════════════════════════════════
       DADOS MOCKADOS
       ═══════════════════════════════════════════════════════════ */
    const mockData = {
      // Dados fictícios realistas para popular todas as telas
      // Valores monetários, nomes, datas, categorias, etc.
    };

    /* ═══════════════════════════════════════════════════════════
       INTERAÇÕES
       ═══════════════════════════════════════════════════════════ */
    // Modais, bottom sheets, toasts, formulários, etc.
  </script>
</body>
</html>
```

## Regra Central de Navegação — OBRIGATÓRIO

**O protótipo high-fi DEVE simular uma aplicação real.**
O usuário que valida o protótipo não pode precisar de explicação para navegar.
Ele abre o arquivo HTML e usa como se fosse o produto de verdade.

### O que isso significa na prática:
- **Toda tela está conectada às demais** via links, botões, menus e gestos navegáveis
- **Nenhum elemento interativo fica "morto"** — todo botão, link, item de menu e CTA leva a algum lugar
- **Fluxos completos de ponta a ponta** estão implementados
- **Navegação de retorno** sempre disponível (voltar, fechar sheet, fechar drawer)
- **Estados de tela** implementados: vazio, carregado, erro, sucesso
- **Dados simulados realistas** — valores, nomes, datas, categorias preenchidos com conteúdo fictício verossímil

### Fluxos Mínimos Obrigatórios
Todos os fluxos da OST/histórias priorizadas devem estar navegáveis, conforme definido no mapa de fluxo do low-fi aprovado.

## Critérios de Qualidade
- [ ] **Arquivo HTML único** — tudo inline (CSS + JS + HTML), sem arquivos separados
- [ ] **Tokens extraídos do design_spec.md** — nenhuma cor, fonte ou espaçamento inventado
- [ ] **Regra de ouro do design_spec.md** respeitada
- [ ] **Fonte importada via Google Fonts CDN** (único recurso externo permitido)
- [ ] **Shell completa** — sidebar/topbar (web) ou bottom nav (mobile) conforme design_spec.md
- [ ] **Todos os fluxos do mapa de fluxo navegáveis** de ponta a ponta
- [ ] **Nenhum botão ou link morto** — todo elemento interativo funciona
- [ ] **Botão/gesto de retorno** disponível em todas as telas internas
- [ ] **Dados fictícios realistas** preenchidos em todas as telas
- [ ] **Estados de tela** implementados: vazio, carregado, sucesso, erro
- [ ] **Hover e focus states** implementados conforme design_spec.md
- [ ] **Funciona via file://** — sem servidor
- [ ] **100% fiel ao design_spec.md** — se abrir o protótipo ao lado do spec, devem ser consistentes

## Output JSON
```json
{
  "agent": "product-designer",
  "skill": "high-fi-prototyper",
  "output": "{REPO_DESTINO}/02-product-discovery/prototype/high-fi.html",
  "format": "single-html-fullspec",
  "design_spec_used": "{REPO_DESTINO}/design_spec.md",
  "risks_mitigated": ["usability", "customer_value"],
  "flows_covered": [],
  "screens_count": 0,
  "identity_compliant": true,
  "feedback_needed": []
}
```
