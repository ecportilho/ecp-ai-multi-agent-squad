# Skill: responsive-guidelines

## Objetivo
Definir comportamento responsivo da interface o produto (conforme design_spec.md).

## Web — Breakpoints
```
Mobile  (<768px):  sidebar oculta → bottom bar ou hamburger
Tablet  (768-1024px): sidebar colapsada (apenas ícones, 72px)
Desktop (>1024px): sidebar expandida (280px) + topbar
```

## Layout Shell
```
Desktop: grid sidebar(280px) + main
Tablet:  grid sidebar(72px) + main
Mobile:  main full-width + bottom nav
```

## Cards e Grid
```
Desktop: grid 3-4 colunas  gap=24px
Tablet:  grid 2 colunas    gap=16px
Mobile:  grid 1 coluna     gap=12px
```

## Tipografia Responsiva
```
Page title: text-2xl sm:text-3xl lg:text-4xl
Card title: text-sm  (fixo)
Body: text-sm md:text-base
```

## Android (NativeWind)
- Usar flex e % em vez de dimensões fixas
- padding: 16 (edge) / gap: 12
- Bottom nav sempre visível (fixed bottom)
- Top app bar sticky

## iOS
- Respeitar safe-area-inset em todo o layout
- Tab bar segue safe area inferior
- Margins laterais: 16pt
