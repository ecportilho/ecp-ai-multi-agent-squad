# Performance Subagent — Front End Developer

## Quando Acionar
Acionado pelo Front End Developer Agent antes do HITL #9 ou ao detectar degradação de performance.
Verificação obrigatória: LCP, CLS e INP devem estar dentro dos thresholds antes de cada release.

## Responsabilidade
Garantir Core Web Vitals positivos e bundle otimizado no Next.js 15.

## Skills
| Skill | Arquivo | Quando Usar |
|-------|---------|-------------|
| `core-web-vitals-monitor` | `core-web-vitals-monitor.md` | Medir LCP < 2.5s, CLS < 0.1, INP < 200ms |
| `rendering-strategist` | `rendering-strategist.md` | Decidir Server vs Client Component por rota |
| `bundle-optimizer` | `bundle-optimizer.md` | Dynamic imports, code splitting, análise de bundle |
| `caching-strategist` | `caching-strategist.md` | Fetch cache, Route Segment Config, Upstash Redis |
