# Skill — core-web-vitals-monitor

## Objetivo
Medir e otimizar LCP, CLS e INP do o produto.

## Metas
- LCP (Largest Contentful Paint): < 2.5s
- CLS (Cumulative Layout Shift): < 0.1
- INP (Interaction to Next Paint): < 200ms

## Como medir
```javascript
// Usando web-vitals via CDN
import { onLCP, onCLS, onINP } from 'https://unpkg.com/web-vitals/dist/web-vitals.attribution.js';
onLCP(console.log);
onCLS(console.log);
onINP(console.log);
```
