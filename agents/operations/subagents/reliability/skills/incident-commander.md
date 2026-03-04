# Skill — incident-commander

## Objetivo
Conduzir resposta a incidentes com runbook e comunicação clara (Google SRE).

## Runbook do o produto
1. **Identificar:** qual endpoint ou funcionalidade está falhando?
2. **Isolar:** o problema é no servidor, nos dados JSON ou no front end?
3. **Mitigar:** reiniciar servidor | restaurar backup JSON | rollback de código
4. **Comunicar:** documentar o que aconteceu e o impacto
5. **Resolver:** corrigir causa raiz
6. **Postmortem:** documentar aprendizados

## Comandos de Emergência

> **Nota:** Os comandos abaixo são cross-platform. Use o terminal do seu sistema (PowerShell no Windows, Terminal no macOS/Linux).

```bash
# Reiniciar servidor de desenvolvimento
# (pnpm dev reinicia automaticamente com hot-reload)
# Se precisar matar o processo na porta:
#   Windows PowerShell: netstat -ano | findstr :3000 → taskkill /PID <PID> /F
#   macOS/Linux: kill -9 $(lsof -ti:3000)

# Restaurar backup de dados (cross-platform com Node.js)
node -e "require('fs').cpSync('backup/data-YYYYMMDD/boards.json', 'app/backend/data/boards.json')"

# Rollback de código (git é cross-platform)
git stash
# Depois reiniciar o servidor de desenvolvimento
pnpm dev
```
