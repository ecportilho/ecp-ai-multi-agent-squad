# Skill — toil-reducer

## Objetivo
Identificar e eliminar trabalho manual repetitivo e sem valor (Google SRE — Toil).

## O que é Toil
Trabalho manual, repetitivo, sem valor duradouro, que escala com o volume.

## Candidatos a Automação no o produto
- Backup manual dos JSONs → script Node.js automático pré-deploy (`scripts/deploy.mjs`)
- Restart manual após crash → `pnpm dev` com hot-reload (ou `nodemon` para produção local)
- Reset de dados de teste → script `npm run seed`
- Verificação manual de logs → structured logging + monitoramento automatizado
