#!/usr/bin/env node

/**
 * ECP AI Squad v3.3 — Application Scaffolder
 * Cria a estrutura padronizada de pastas para o produto.
 *
 * Uso: node scaffold-app.mjs <nome-do-produto>
 */

import { mkdirSync, writeFileSync, existsSync } from 'fs';
import { join } from 'path';

const [,, productName] = process.argv;

if (!productName) {
  console.error('Uso: node scaffold-app.mjs <nome-do-produto>');
  process.exit(1);
}

const root = productName;
if (existsSync(root)) {
  console.error(`Pasta "${root}" já existe.`);
  process.exit(1);
}

const dirs = [
  '.github/workflows',
  '00-specs',
  '01-strategic-context',
  '02-product-discovery/oportunidades',
  '02-product-discovery/hipoteses',
  '02-product-discovery/prototipos',
  '02-product-discovery/backlog',
  '03-product-delivery/architecture',
  '03-product-delivery/adrs',
  '03-product-delivery/test-reports',
  '04-product-operation/slos',
  '04-product-operation/runbooks',
  '04-product-operation/ab-tests',
  '05-docs/api',
  '05-docs/architecture',
  '05-docs/user-guide',
  '06-logs',
  'src/backend',
  'src/frontend',
];

dirs.forEach(dir => mkdirSync(join(root, dir), { recursive: true }));

// .gitignore
writeFileSync(join(root, '.gitignore'), `node_modules/
.env
.env.*
dist/
06-logs/*.log
*.sqlite
*.sqlite-journal
`);

// .gitattributes
writeFileSync(join(root, '.gitattributes'), `*.md linguist-documentation
*.json linguist-data
`);

// 06-logs placeholder
writeFileSync(join(root, '06-logs', 'phase-transitions.log'), '');
writeFileSync(join(root, '06-logs', 'hitl-decisions.log'), '');

// 05-docs/changelog.md
writeFileSync(join(root, '05-docs', 'changelog.md'), `# Changelog\n\nTodas as mudanças do ${productName}.\n`);

console.log(`✅ Estrutura criada para "${productName}" com ${dirs.length} diretórios.`);
