# Skill — deployment-strategist

## Objetivo
Definir estratégia de deploy para o produto com rollback seguro.

## Estratégia Local
- **Deploy:** copiar arquivos para diretório de produção local
- **Rollback:** manter última versão em `/backup/` antes de cada deploy
- **Feature Flags:** controlar novas features sem novo deploy

## Script de Deploy (cross-platform — Node.js)
```javascript
// scripts/deploy.mjs
import { cpSync, mkdirSync } from "node:fs";

const timestamp = new Date().toISOString().replace(/[:.]/g, "-").slice(0, 19);
const backupDir = `backup/app-${timestamp}`;

console.log("🔄 Fazendo backup da versão atual...");
mkdirSync(backupDir, { recursive: true });
cpSync("app/", backupDir, { recursive: true });

console.log("🚀 Iniciando deploy...");
// npm run build é cross-platform (executar via terminal antes)
console.log("Execute: npm run build");
console.log("✅ Backup concluído em:", backupDir);
```

> **Nota:** Em produção, o deploy é feito via Vercel/EAS (CI/CD), não localmente.
> Este script é para ambiente de desenvolvimento local.
> Use `node scripts/deploy.mjs` em qualquer sistema operacional.
