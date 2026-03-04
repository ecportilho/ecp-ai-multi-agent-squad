# Skill — component-documenter

## Objetivo
Documentar componentes HTML/JS com exemplos de uso e variantes.

## Formato
```markdown
## Component: Card

**Uso:**
```html
<div class="card" data-card-id="uuid" draggable="true">
  <div class="card__title">Título da Tarefa</div>
</div>
```

**Variantes:** `.card--overdue`, `.card--priority-high`
**Estados:** default, hover, dragging, selected
**JS:** inicializar com `initCardDrag(el)` após inserir no DOM
