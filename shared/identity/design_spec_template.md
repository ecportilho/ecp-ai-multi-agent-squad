# design_spec.md — Template de Referência

> **Este arquivo é um TEMPLATE.** Copie-o para o repositório do produto e preencha com os valores reais.
> O squad lê o `design_spec.md` do `{REPO_DESTINO}`, não este template.

---

# [Nome do Produto] — Especificação de Design

## Tema
[Dark / Light / Ambos] — descrever o modo principal.

## Paleta de Cores

| Token | Valor Hex | Uso |
|-------|-----------|-----|
| Background | `#??????` | Fundo principal |
| Surface | `#??????` | Cards e painéis |
| Surface Variant | `#??????` | Fundo secundário |
| Border | `#??????` | Bordas padrão |
| Text Primary | `#??????` | Texto principal |
| Text Secondary | `#??????` | Texto secundário |
| Text Muted | `#??????` | Texto terciário |
| Brand Primary | `#??????` | CTAs, foco, destaque |
| Brand Hover | `#??????` | Hover sobre elementos de marca |
| Brand Active | `#??????` | Pressed/active |
| Brand Glow | `rgba(?,?,?,0.20)` | Focus ring |
| Success | `#??????` | Valores positivos |
| Warning | `#??????` | Alertas |
| Danger | `#??????` | Erros, valores negativos |
| Info | `#??????` | Informação |

## Tipografia

| Plataforma | Fonte | Fallback |
|-----------|-------|---------|
| Web | [Nome da fonte] | system-ui, sans-serif |
| Android | [Nome da fonte] | Roboto |
| iOS | [Nome da fonte] | SF Pro |

### Escala Tipográfica

| Token | Tamanho | Peso | Uso |
|-------|---------|------|-----|
| Display | ??px | 700 | Títulos grandes |
| Heading | ??px | 600 | Títulos de seção |
| Body | ??px | 400 | Texto padrão |
| Caption | ??px | 400 | Texto auxiliar |
| Mono | ??px | 500 | Valores numéricos/financeiros |

## Espaçamento

| Token | Valor |
|-------|-------|
| Space XS | ??px |
| Space SM | ??px |
| Space MD | ??px |
| Space LG | ??px |
| Space XL | ??px |

## Border Radius

| Token | Valor | Uso |
|-------|-------|-----|
| Radius SM | ??px | Badges, chips |
| Radius MD | ??px | Cards, inputs |
| Radius LG | ??px | Modais, sheets |
| Radius Pill | 999px | Botões pill |

## Componentes

### Botão Primário
- Background: [token de cor]
- Texto: [token de cor]
- Border radius: [token]
- Padding: ??px ??px
- Hover: [token de cor]
- Active/Pressed: [token de cor]
- Disabled: opacity 0.5

### Botão Secundário
- Background: transparent
- Borda: [token de cor]
- Texto: [token de cor]

### Card
- Background: [token de cor]
- Borda: [token de cor]
- Border radius: [token]
- Padding: [token de espaçamento]

### Input
- Background: [token de cor]
- Borda: [token de cor]
- Border radius: [token]
- Padding: ??px
- Focus: [token de cor] ring

### Navegação (Web)
- Tipo: [Sidebar / Topbar / Ambos]
- Largura sidebar: ??px
- Altura topbar: ??px
- Background: [token de cor]

### Navegação (Mobile)
- Tipo: [Bottom Nav / Tab Bar]
- Altura: ??px
- Items: [máximo ?? items]

## Regra de Ouro
> [Descrever a restrição visual principal que NUNCA deve ser quebrada]
> Exemplo: "A cor de marca é apenas para CTAs e foco. Nunca usar como fundo dominante."

## Design Tokens em CSS (opcional mas recomendado)
```css
:root {
  /* Colar aqui todos os tokens em formato CSS custom properties */
}
```

## Breakpoints (Web)

| Token | Largura |
|-------|---------|
| Mobile | < ??px |
| Tablet | ??px - ??px |
| Desktop | > ??px |

## Animações e Transições

| Tipo | Duração | Easing |
|------|---------|--------|
| Base | ??ms | [curva] |
| Entrada | ??ms | [curva] |
| Saída | ??ms | [curva] |

## Acessibilidade
- Contraste mínimo texto/fundo: [ratio]
- Focus ring visível em todos os interativos
- Tamanho mínimo de alvo touch: ??px
