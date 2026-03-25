#!/usr/bin/env node
// =============================================================================
// validate-inputs.mjs — Pre-flight check do ECP AI Squad (cross-platform)
// =============================================================================
// Valida os 4 inputs obrigatórios antes de iniciar qualquer fase.
// Uso: node validate-inputs.mjs <REPO_DESTINO>
//
// Retorna exit code 0 se tudo OK, 1 se houver erro.
// Funciona em Windows, macOS e Linux sem dependências externas.
// =============================================================================

import { existsSync, readFileSync, mkdirSync } from "node:fs";
import { resolve, join } from "node:path";

// ─── Cores (suportadas no Windows Terminal, PowerShell 7 e Git Bash) ────────
const RED = "\x1b[31m";
const GREEN = "\x1b[32m";
const YELLOW = "\x1b[33m";
const NC = "\x1b[0m";

let errors = 0;

console.log("");
console.log("╔══════════════════════════════════════════════════════════╗");
console.log("║        ECP AI Squad — Pre-Flight Check (v3.1)           ║");
console.log("╚══════════════════════════════════════════════════════════╝");
console.log("");

// ─── Validar argumento: repositório destino ─────────────────────────────────
const repoDestino = process.argv[2];

if (!repoDestino) {
  console.log(`${RED}❌ ERRO: Nenhum repositório destino informado.${NC}`);
  console.log("");
  console.log("Uso: node validate-inputs.mjs <REPO_DESTINO>");
  console.log("");
  console.log("Exemplo: node validate-inputs.mjs ../meu-produto");
  console.log("");
  console.log("O repositório destino deve conter os 3 arquivos obrigatórios:");
  console.log("  - product_briefing_spec.md");
  console.log("  - tech_spec.md");
  console.log("  - design_spec.md");
  process.exit(1);
}

const repoPath = resolve(repoDestino);

// ─── 1. Validar repositório destino ─────────────────────────────────────────
console.log(`📁 Validando repositório destino: ${repoPath}`);
if (existsSync(repoPath)) {
  console.log(`   ${GREEN}✅ Diretório existe${NC}`);
} else {
  console.log(`   ${YELLOW}⚠️  Diretório não existe — criando...${NC}`);
  mkdirSync(repoPath, { recursive: true });
  console.log(`   ${GREEN}✅ Diretório criado${NC}`);
}
console.log("");

// ─── Função auxiliar: validar arquivo com seções ────────────────────────────
function validateFile(label, filePath, requiredSections) {
  console.log(`📄 Validando ${label}`);

  if (!existsSync(filePath)) {
    console.log(`   ${RED}❌ ERRO: Arquivo não encontrado${NC}`);
    console.log(`   ${RED}   Esperado em: ${filePath}${NC}`);
    errors++;
    console.log("");
    return;
  }

  console.log(`   ${GREEN}✅ Arquivo existe${NC}`);

  const content = readFileSync(filePath, "utf-8").toLowerCase();

  for (const section of requiredSections) {
    if (content.includes(section.toLowerCase())) {
      console.log(`   ${GREEN}✅ Seção '${section}' encontrada${NC}`);
    } else {
      console.log(
        `   ${YELLOW}⚠️  Seção '${section}' não encontrada (recomendada)${NC}`
      );
    }
  }
  console.log("");
}

// ─── 2. Validar product_briefing_spec.md ────────────────────────────────────
validateFile(
  "product_briefing_spec.md",
  join(repoPath, "product_briefing_spec.md"),
  ["Produto", "Problema", "Público", "Regras de Negócio"]
);

// ─── 3. Validar tech_spec.md ────────────────────────────────────────────────
validateFile("tech_spec.md", join(repoPath, "tech_spec.md"), [
  "Stack",
  "Arquitetura",
  "Regras",
  "Deploy",
]);

// ─── 4. Validar design_spec.md ─────────────────────────────────────────────
validateFile("design_spec.md", join(repoPath, "design_spec.md"), [
  "Paleta",
  "Tipografia",
  "Componentes",
]);

// ─── Resultado final ────────────────────────────────────────────────────────
console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
if (errors === 0) {
  console.log(
    `${GREEN}🚀 PRE-FLIGHT CHECK APROVADO — Squad pronto para iniciar!${NC}`
  );
  console.log("");
  console.log(`Repositório destino: ${repoPath}`);
  console.log("Inputs validados:    3/3");
  console.log("");
  console.log("Para iniciar, abra o Claude Code neste diretório e execute:");
  console.log(
    `  Inicie a Fase 01 com repositório destino em ${repoDestino}`
  );
  process.exit(0);
} else {
  console.log(
    `${RED}🛑 PRE-FLIGHT CHECK FALHOU — ${errors} erro(s) encontrado(s)${NC}`
  );
  console.log("");
  console.log("Corrija os erros acima antes de iniciar o squad.");
  console.log(
    "Consulte shared/schemas/input-contracts.md para ver a estrutura esperada de cada arquivo."
  );
  process.exit(1);
}
