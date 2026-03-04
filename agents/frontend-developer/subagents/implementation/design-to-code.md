# Skill: design-to-code

## Objetivo
Traduzir specs do UI Agent e protótipos de referência para código Next.js + Tailwind + shadcn/ui.

## Identidade Visual (OBRIGATÓRIO — ler antes de implementar)
- `{REPO_DESTINO}/design_spec.md`
- `{REPO_DESTINO}/design_spec.md (protótipo de referência)` ← **implementação CSS de referência**

## Configuração Base (globals.css)
Copiar as CSS variables do protótipo de referência para `apps/web/src/styles/globals.css`.
Os tokens estão definidos na skill `design-tokens` do UI Agent.

## Componentes shadcn/ui Customizados

### Button (Primary — lime)
```tsx
// components/ui/button.tsx já gerado pelo shadcn
// Usar variant="default" → automaticamente lime via CSS variables
<Button className="rounded-full font-semibold">
  Confirmar
</Button>
```

### Card (ECP surface)
```tsx
<div className="rounded-lg border border-ecp-border-subtle bg-ecp-surface p-5 shadow-ecp-sm">
  <div className="flex items-center justify-between pb-4 border-b border-ecp-border-subtle">
    <h3 className="text-sm font-semibold text-ecp-text">Título</h3>
  </div>
  <div className="pt-4">
    {/* conteúdo */}
  </div>
</div>
```

### Valor financeiro (tabular-nums)
```tsx
<span className="font-bold tabular-nums text-ecp-text">
  {new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" })
    .format(amountCents / 100)}
</span>

// Positivo
<span className="text-ecp-success tabular-nums">+R$ 1.000,00</span>
// Negativo
<span className="text-ecp-danger tabular-nums">-R$ 500,00</span>
```

### Sidebar (Desktop)
```tsx
<aside className="hidden lg:flex flex-col w-[280px] min-h-screen bg-ecp-bg border-r border-ecp-border-subtle">
  {/* Logo */}
  {/* Nav items */}
</aside>
```

### Nav Item (com estado ativo)
```tsx
<Link
  href={href}
  className={cn(
    "flex items-center gap-3 px-3 h-11 rounded-[10px] text-sm font-medium transition-colors duration-[140ms]",
    isActive
      ? "bg-ecp-surface-2 text-ecp-lime border-l-[3px] border-ecp-lime pl-[9px]"
      : "text-ecp-text-secondary hover:bg-ecp-surface-2 hover:text-ecp-text"
  )}
>
  {children}
</Link>
```

### Focus ring lime
```tsx
// Adicionar globalmente via globals.css
// :focus-visible { box-shadow: 0 0 0 4px rgba(183,255,42,0.20); outline: none; }
```

## Checklist de Fidelidade
- [ ] globals.css com tokens o produto (conforme design_spec.md) configurados
- [ ] tailwind.config.ts com extensão de cores ecp-*
- [ ] shadcn/ui com CSS variables apontando para paleta o produto (conforme design_spec.md)
- [ ] Fonte Inter carregada via next/font/google
- [ ] tabular-nums em TODOS os valores financeiros
- [ ] Focus ring lime em elementos interativos
- [ ] Sidebar 280px no desktop, oculta no mobile
- [ ] Topbar 64px sticky com backdrop-blur
- [ ] Bottom nav no mobile (se aplicável)
