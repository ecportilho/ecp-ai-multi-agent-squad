---
name: visual-consistency-checker
description: >
  Verificar fidelidade visual do produto implementado em relação ao design_spec.md e protótipo high-fi. Use antes de cada HITL de design (#5, #9) para garantir que a implementação segue a identidade visual.
---

# Skill: visual-consistency-checker

## Objetivo
Verificar se protótipos e entregas de código estão fiéis à identidade visual do produto (conforme design_spec.md).
Referência: `{REPO_DESTINO}/design_spec.md`

## Checklist Web
- [ ] Background principal = `#0b0f14`
- [ ] Surface/cards = `#131c28` com border `#1c2836`
- [ ] CTAs primários = lime `#b7ff2a` com texto `#0b0f14`
- [ ] Focus ring = `rgba(183,255,42,0.20)`
- [ ] Fonte = Inter com font-variant-numeric tabular-nums em valores
- [ ] Sidebar 280px com ativo em lime
- [ ] Topbar 64px sticky com backdrop-blur
- [ ] Valores positivos = `#3dff8b` / negativos = `#ff4d4d`

## Checklist Android
- [ ] Bottom navigation com 5 itens, ativo em lime
- [ ] Top App Bar 56dp
- [ ] Cards com radius=18 e shadow suave
- [ ] Quick Actions em grid 4 colunas com ícone lime
- [ ] Touch targets >= 48dp
- [ ] Bottom sheet com grab handle

## Checklist iOS
- [ ] Tab bar com tintColor lime
- [ ] Navigation bar com large title
- [ ] Sheet nativa (não drawer lateral)
- [ ] Segmented control no Pix
- [ ] Touch targets >= 44pt
- [ ] Valores com monospacedDigit

## Anti-patterns a Rejeitar
- ❌ Lime como cor de fundo dominante (apenas CTAs e foco)
- ❌ Texto branco puro (#ffffff) — usar #eaf2ff
- ❌ Backgrounds claros (o tema é sempre dark)
- ❌ Radius < 14px em cards
- ❌ Valores financeiros sem tabular-nums
- ❌ Botão primário com cor diferente de lime
