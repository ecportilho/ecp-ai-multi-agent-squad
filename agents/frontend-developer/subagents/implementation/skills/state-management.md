# Skill — state-management

## Objetivo
Gerenciar estado da aplicação sem framework — padrão store simples.

## Store Simples
```javascript
// js/store.js
const store = {
  _state: { boards: [], currentBoard: null, columns: [], cards: [] },
  _listeners: [],

  getState: () => ({ ...store._state }),

  setState: (updates) => {
    store._state = { ...store._state, ...updates };
    store._listeners.forEach(fn => fn(store._state));
  },

  subscribe: (fn) => {
    store._listeners.push(fn);
    return () => { store._listeners = store._listeners.filter(l => l !== fn); };
  }
};
```
