---
name: performance-tester
description: >
  Criar e executar scripts de carga e stress para validar thresholds de performance em produção. Use antes de releases importantes e sempre que novos endpoints críticos forem adicionados.
---

# Skill: performance-tester

## Objetivo
Validar performance da API e do front end contra os SLOs definidos.

## API Performance (k6 ou autocannon)
```bash
# Instalar autocannon
npm install -g autocannon

# Testar endpoint tRPC (HTTP POST)
autocannon -c 50 -d 30 http://localhost:3000/api/trpc/resource.list
```

## Core Web Vitals (Playwright)
```typescript
test("should meet Core Web Vitals", async ({ page }) => {
  await page.goto("/dashboard");
  const lcp = await page.evaluate(() =>
    new Promise(resolve => new PerformanceObserver(list => {
      resolve(list.getEntries().at(-1)?.startTime);
    }).observe({ type: "largest-contentful-paint", buffered: true }))
  );
  expect(lcp).toBeLessThan(2500); // LCP < 2.5s
});
```

## SLOs de Performance
| Métrica | Target |
|---------|--------|
| tRPC P95 | < 500ms |
| LCP | < 2.5s |
| CLS | < 0.1 |
| INP | < 200ms |
| Build time CI | < 5 min |
