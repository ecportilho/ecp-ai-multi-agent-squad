---
name: responsive-implementer
description: >
  Implementar layouts responsivos com Tailwind seguindo breakpoints do design_spec.md. Use ao criar layouts que devem funcionar em mobile, tablet e desktop.
---

# Skill: responsive-implementer

## Objetivo
Implementar responsividade com Tailwind CSS mobile-first.

## Breakpoints Tailwind
```
sm: 640px   — mobile landscape
md: 768px   — tablet
lg: 1024px  — desktop
xl: 1280px  — large desktop
2xl: 1536px — ultra-wide
```

## Padrão Mobile-First
```tsx
// ✅ Mobile first — sem prefixo = mobile, prefixo = desktop
<div className="
  flex flex-col gap-4           // mobile: coluna
  md:flex-row md:gap-8          // tablet+: linha
  lg:max-w-5xl lg:mx-auto       // desktop: largura máxima
">

// ✅ Grid responsivo
<div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">

// ✅ Sidebar responsiva
<aside className="hidden lg:flex lg:w-64 lg:flex-col">

// ✅ Typography responsiva
<h1 className="text-2xl font-bold sm:text-3xl lg:text-4xl">
```

## Regras
- Mobile first: estilos base = mobile
- NUNCA media queries em CSS — usar Tailwind breakpoint prefixes
- Testar em 375px (iPhone SE), 768px (iPad), 1280px (desktop)
