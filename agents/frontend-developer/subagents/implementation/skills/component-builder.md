# Skill — component-builder

## Objetivo
Construir componentes reutilizáveis HTML/CSS/JS seguindo o design system do o produto.

## Padrão de Componente
```javascript
// js/components/card.js
const createCardElement = (card) => {
  const el = document.createElement('div');
  el.className = 'card';
  el.dataset.cardId = card.id;
  el.draggable = true;
  el.innerHTML = `
    <div class="card__title">${card.title}</div>
    ${card.dueDate ? `<div class="card__due">${formatDate(card.dueDate)}</div>` : ''}
    <div class="card__footer">
      ${card.labels.map(l => `<span class="badge badge--${l.color}">${l.name}</span>`).join('')}
    </div>
  `;
  return el;
};
```

## Componentes do o produto
- `card.js` — Card Kanban com drag handle
- `column.js` — Coluna com header, cards e add card button
- `board-header.js` — Header com título e ações do board
- `modal.js` — Modal genérico para Card Detail e forms
- `toast.js` — Notificações temporárias
