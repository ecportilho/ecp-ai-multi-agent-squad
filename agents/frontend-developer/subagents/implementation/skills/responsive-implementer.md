# Skill — responsive-implementer

## Objetivo
Implementar layouts responsivos seguindo as guidelines do UI Agent.

## Media Queries do o produto
```css
/* Mobile first */
.board-columns { display: flex; overflow-x: auto; gap: var(--space-md); }

/* Tablet */
@media (min-width: 768px) {
  .board-columns { min-width: max-content; }
}

/* Desktop */
@media (min-width: 1024px) {
  .app-layout { display: grid; grid-template-columns: 240px 1fr; }
}
```
