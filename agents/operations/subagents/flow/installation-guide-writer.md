# Skill: installation-guide-writer

## Objetivo
Gerar um guia de instalação completo, detalhado e acessível — escrito de forma que qualquer pessoa, sem experiência técnica prévia, consiga colocar todos os componentes da aplicação no ar seguindo os passos em ordem.

## Quando Executar
Executar após o HITL #12, junto com a geração do site de documentação (`docs-generator`).

## Localização do Output
```
{REPO_DESTINO}/docs/INSTALACAO.md
```
Também incluído como página `instalacao.html` no site de documentação.

---

## Princípios de Escrita

### Tom e linguagem
- Escrever como se estivesse ensinando uma criança de 10 anos curiosa e inteligente
- Nunca assumir que o leitor sabe o que é um "terminal", "variável de ambiente" ou "banco de dados"
- Explicar o PORQUÊ de cada passo — não só o que fazer
- Usar analogias simples quando necessário (ex: "o banco de dados é como uma planilha enorme que guarda todas as informações do app")
- Tom amigável, encorajador e paciente — erros são normais e o guia deve prever os mais comuns

### Estrutura de cada passo
Todo passo deve conter:
1. **O que vamos fazer** — título claro
2. **Por que precisamos fazer isso** — contexto
3. **Como fazer** — instrução passo a passo com comandos exatos
4. **Como testar se funcionou** — verificação concreta antes de avançar
5. **O que fazer se der errado** — erros comuns e soluções

---

## Estrutura Completa do Guia

```markdown
# 🚀 Guia de Instalação — [Nome da Aplicação]

> **Para quem é esse guia?**
> Para qualquer pessoa que queira instalar e rodar essa aplicação no seu computador.
> Não precisa saber programar. Só precisa seguir os passos com calma, um de cada vez.
>
> **Quanto tempo leva?**
> Entre 30 e 60 minutos na primeira vez. Nas próximas vezes, menos de 5 minutos.
>
> **O que você vai precisar?**
> - Um computador com acesso à internet
> - Paciência para seguir os passos com atenção
> - Nada mais!

---

## 📋 Índice

1. [Entendendo o que vamos instalar](#1-entendendo)
2. [Preparando seu computador](#2-preparando)
3. [Instalando o Node.js](#3-nodejs)
4. [Instalando o pnpm](#4-pnpm)
5. [Baixando o código da aplicação](#5-codigo)
6. [Configurando o banco de dados (Supabase)](#6-supabase)
7. [Configurando o cache (Upstash Redis)](#7-upstash)
8. [Configurando as variáveis de ambiente](#8-env)
9. [Instalando as dependências do projeto](#9-dependencias)
10. [Preparando o banco de dados](#10-banco)
11. [Rodando a aplicação localmente](#11-rodando)
12. [Verificando se tudo está funcionando](#12-verificando)
13. [Fazendo o deploy (colocando no ar para todos verem)](#13-deploy)
14. [O que fazer se algo der errado](#14-erros)

---

## 1. Entendendo o que vamos instalar {#1-entendendo}

### O que é essa aplicação?
[Descrição simples do produto em 2–3 frases acessíveis]

### De que partes ela é feita?
Pense na aplicação como uma casa. Ela tem várias partes que precisam funcionar juntas:

| Parte | O que é | Analogia |
|-------|---------|---------|
| **Front End Web** | A parte visual que você vê no navegador | A fachada e os cômodos da casa |
| **App Mobile** | O aplicativo no celular | Uma porta de entrada diferente para a mesma casa |
| **Back End (API)** | O servidor que processa as informações | A cozinha — onde tudo é preparado, mas você não vê |
| **Banco de Dados** | Onde todas as informações são guardadas | O arquivo onde a casa guarda todos os documentos |
| **Cache** | Armazenamento rápido para informações frequentes | Post-its colados na geladeira para lembrar o mais importante |
| **Fila de Jobs** | Processamento de tarefas em segundo plano | O carteiro que entrega cartas enquanto você dorme |

### Diagrama da aplicação
```
Você (navegador/celular)
        ↓
   Front End Web (Next.js) ─── App Mobile (Expo)
        ↓
   API (tRPC) — valida, processa, responde
        ↓
   Banco de Dados (Supabase PostgreSQL)
   Cache (Upstash Redis)
   Fila (Upstash QStash)
```

---

## 2. Preparando seu computador {#2-preparando}

### O que é o terminal e por que vamos usá-lo?
O terminal (também chamado de "linha de comando") é como dar instruções diretamente ao computador usando texto, em vez de clicar com o mouse. É mais eficiente para instalar programas e configurar aplicações.

### Como abrir o terminal?

**No macOS (Mac):**
1. Aperte as teclas `Cmd + Espaço` ao mesmo tempo
2. Digite `Terminal`
3. Aperte Enter
4. Uma janela preta (ou branca) vai aparecer — esse é o terminal!

**No Windows:**
1. Aperte as teclas `Windows + R` ao mesmo tempo
2. Digite `cmd` e aperte Enter
3. Ou pesquise por "PowerShell" no menu iniciar

**No Linux:**
1. Aperte `Ctrl + Alt + T`

### Como saber se um comando funcionou?
Quando você digita um comando e aperta Enter, o terminal executa e mostra o resultado.
- ✅ Se não aparecer mensagem de erro, geralmente funcionou
- ❌ Palavras como `error`, `not found`, `permission denied` indicam problema
- Sempre leia o que aparecer antes de continuar

---

## 3. Instalando o Node.js {#3-nodejs}

### O que é o Node.js e por que preciso dele?
Node.js é como o "motor" que faz o JavaScript (a linguagem de programação usada nessa aplicação) funcionar no seu computador. Sem ele, nada funciona. É como tentar ligar um carro sem motor.

### Como instalar?

**Passo 1:** Acesse o site oficial: https://nodejs.org
**Passo 2:** Clique no botão verde grande que diz **"LTS"** (não o "Current")
> 💡 *LTS significa "Long Term Support" — é a versão mais estável e recomendada*

**Passo 3:** Baixe e execute o instalador para o seu sistema operacional
**Passo 4:** Siga o assistente de instalação clicando em "Next" / "Avançar" em todas as telas

### ✅ Como testar se funcionou?
Abra o terminal e digite exatamente isso (depois aperte Enter):
```bash
node --version
```
Você deve ver algo como:
```
v20.11.0
```
Se aparecer um número começando com `v20` ou maior — funcionou! 🎉
Se aparecer `node: command not found` — o Node.js não foi instalado corretamente. Tente instalar de novo.

---

## 4. Instalando o pnpm {#4-pnpm}

### O que é o pnpm e por que preciso dele?
pnpm é um gerenciador de pacotes — ele é responsável por baixar e organizar todas as "peças" (bibliotecas) que a aplicação precisa para funcionar. É como um assistente de compras que busca tudo que você precisa na internet.

> 💡 *Existe outro gerenciador chamado `npm` que já vem com o Node.js, mas o pnpm é mais rápido e eficiente. É como comparar uma bicicleta (npm) com um carro (pnpm).*

### Como instalar?
No terminal, digite e aperte Enter:
```bash
npm install -g pnpm
```
> 💡 *O `-g` significa "global" — instalar para todo o computador, não só para um projeto*

### ✅ Como testar se funcionou?
```bash
pnpm --version
```
Deve aparecer algo como `9.0.0` ou maior. Se aparecer — funcionou! 🎉

---

## 5. Baixando o código da aplicação {#5-codigo}

### O que é o Git e por que precisamos dele?
Git é um sistema que guarda versões do código. É como um histórico completo de todas as mudanças que já foram feitas na aplicação. Vamos usá-lo para baixar o código.

### Instalando o Git (se necessário)
Verifique se já tem o Git:
```bash
git --version
```
Se aparecer um número de versão — já tem instalado! Se não, baixe em: https://git-scm.com/downloads

### Escolhendo onde salvar o projeto
Primeiro, vamos navegar até a pasta onde você quer salvar o projeto.
Sugestão: criar uma pasta chamada `projetos` na sua pasta de usuário:

```bash
# Criar a pasta (só precisa fazer uma vez)
mkdir ~/projetos

# Entrar na pasta
cd ~/projetos
```
> 💡 *O `~` é um atalho para "minha pasta de usuário" (ex: /Users/joao no Mac ou C:\Users\joao no Windows)*

### Baixando o código
```bash
git clone https://github.com/[seu-usuario]/[nome-do-repositorio].git
```
> ⚠️ *Substitua `[seu-usuario]` e `[nome-do-repositorio]` pelos valores reais do seu repositório no GitHub*

```bash
# Entrar na pasta do projeto
cd [nome-do-repositorio]
```

### ✅ Como testar se funcionou?
```bash
ls
```
Deve aparecer uma lista de arquivos e pastas, incluindo `package.json`, `apps/`, `packages/`, etc.

---

## 6. Configurando o banco de dados (Supabase) {#6-supabase}

### O que é o Supabase?
Supabase é o serviço que vai guardar todos os dados da aplicação — usuários, transações, e tudo mais. É como contratar um serviço de armazenamento na nuvem, mas para banco de dados. O plano gratuito já é suficiente para começar.

### Passo a Passo

**Passo 1 — Criar uma conta gratuita:**
1. Acesse https://supabase.com
2. Clique em "Start your project"
3. Faça login com sua conta do GitHub (mais fácil) ou crie uma conta com e-mail

**Passo 2 — Criar um novo projeto:**
1. Clique em "New project"
2. Preencha:
   - **Name:** `[nome-da-aplicacao]-prod` (ex: `ecp-bank-prod`)
   - **Database Password:** crie uma senha forte e **GUARDE ELA** em algum lugar seguro
   - **Region:** escolha `South America (São Paulo)` para menor latência no Brasil
3. Clique em "Create new project"
4. Aguarde 1–2 minutos enquanto o Supabase configura tudo

**Passo 3 — Pegar as credenciais:**
1. No painel do Supabase, clique em **"Settings"** (engrenagem no menu lateral)
2. Clique em **"API"**
3. Você vai ver:
   - **Project URL** — algo como `https://abcdef.supabase.co`
   - **anon public** — uma chave longa começando com `eyJ`
   - **service_role** — outra chave longa (⚠️ mantenha esta secreta!)

4. Clique em **"Database"** no menu
5. Você vai ver a **Connection string** — copie a versão "URI" (começa com `postgresql://`)

> 💡 *Guarde todas essas informações — vamos precisar delas no passo 8*

### ✅ Como testar se funcionou?
Se o painel do Supabase carregou e você conseguiu ver as credenciais — funcionou! 🎉

---

## 7. Configurando o cache (Upstash) {#7-upstash}

### O que é o Upstash Redis?
Redis é como uma memória super-rápida para a aplicação. Em vez de buscar informações no banco de dados toda vez (o que é mais lento), a aplicação guarda as informações mais usadas no Redis e busca de lá. É como ter um Post-it na frente dos olhos em vez de ir até o arquivo toda vez.

### Passo a Passo

**Passo 1 — Criar uma conta gratuita:**
1. Acesse https://upstash.com
2. Clique em "Start for free"
3. Faça login com GitHub ou crie uma conta

**Passo 2 — Criar um banco Redis:**
1. Clique em "Create Database"
2. Preencha:
   - **Name:** `[nome-da-aplicacao]-cache`
   - **Type:** Regional
   - **Region:** `South America (São Paulo)`
3. Clique em "Create"

**Passo 3 — Pegar as credenciais:**
1. Clique no banco que acabou de criar
2. Na aba "Details", copie:
   - **UPSTASH_REDIS_REST_URL**
   - **UPSTASH_REDIS_REST_TOKEN**

**Passo 4 — Criar uma fila QStash (para jobs em segundo plano):**
1. No menu lateral, clique em "QStash"
2. Copie o **QSTASH_TOKEN**, **QSTASH_CURRENT_SIGNING_KEY** e **QSTASH_NEXT_SIGNING_KEY**

### ✅ Como testar se funcionou?
Se você conseguiu copiar as credenciais do Redis e do QStash — funcionou! 🎉

---

## 8. Configurando as variáveis de ambiente {#8-env}

### O que são variáveis de ambiente?
Variáveis de ambiente são como um arquivo de configurações secretas da aplicação — senhas, endereços de serviços, chaves de acesso. Elas ficam em um arquivo especial chamado `.env.local` que **nunca** é enviado para o GitHub (por isso seus dados ficam seguros).

> 💡 *É como o cofre da aplicação. Cada pessoa que instala o projeto tem o próprio cofre com as próprias chaves.*

### Criando o arquivo de configuração

No terminal, dentro da pasta do projeto, execute:
```bash
# Copiar o arquivo de exemplo
cp .env.example .env.local
```

Agora abra o arquivo `.env.local` com qualquer editor de texto:
- **No Mac:** `open -e .env.local`
- **No Windows:** `notepad .env.local`
- **Com VS Code (recomendado):** `code .env.local`

### Preenchendo cada variável
Substitua os valores de exemplo pelos seus valores reais:

```bash
# ===== SUPABASE =====
# Cole o "Project URL" do painel do Supabase
NEXT_PUBLIC_SUPABASE_URL=https://SEU-ID.supabase.co

# Cole a chave "anon public" do Supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...sua-chave-anon...

# Cole a chave "service_role" do Supabase (⚠️ nunca compartilhe!)
SUPABASE_SERVICE_ROLE_KEY=eyJ...sua-service-role...

# Cole a connection string do banco (com pgbouncer para produção)
DATABASE_URL=postgresql://postgres.[ID]:[SENHA]@pooler.supabase.com:6543/postgres?pgbouncer=true

# Cole a connection string direta (para migrations)
DATABASE_URL_DIRECT=postgresql://postgres.[ID]:[SENHA]@pooler.supabase.com:5432/postgres

# ===== UPSTASH =====
# Cole as credenciais do Redis que você copiou no passo 7
UPSTASH_REDIS_REST_URL=https://...upstash.io
UPSTASH_REDIS_REST_TOKEN=AX...

# Cole as credenciais do QStash
QSTASH_TOKEN=eyJ...
QSTASH_CURRENT_SIGNING_KEY=sig_...
QSTASH_NEXT_SIGNING_KEY=sig_...

# ===== APP =====
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development
```

> ⚠️ **IMPORTANTE:** Nunca envie o arquivo `.env.local` para o GitHub. Ele já está no `.gitignore` por padrão, mas certifique-se disso.

### ✅ Como testar se funcionou?
```bash
# Verificar se o arquivo existe e tem conteúdo
cat .env.local
```
Se aparecer o conteúdo com suas chaves preenchidas — funcionou! 🎉

---

## 9. Instalando as dependências do projeto {#9-dependencias}

### O que são dependências?
Dependências são todas as "peças prontas" que outras pessoas criaram e que nossa aplicação usa. Em vez de construir tudo do zero, usamos código já feito e testado — como usar tijolos prontos em vez de fabricar do zero.

### Como instalar?
Na pasta raiz do projeto, execute:
```bash
pnpm install
```
> 💡 *Isso pode levar de 1 a 5 minutos na primeira vez — o pnpm está baixando centenas de pacotes da internet*

Você vai ver muitas linhas aparecendo — isso é normal! Quando parar e voltar ao cursor piscando, terminou.

### ✅ Como testar se funcionou?
```bash
# Verificar se a pasta de dependências foi criada (cross-platform)
npx ls-engines
# Ou simplesmente: se a pasta node_modules existe, funcionou!
# Windows PowerShell: dir node_modules
# macOS/Linux: ls node_modules | head -5
```
Se aparecer nomes de pastas — funcionou! 🎉

Se aparecer erro de permissão no Mac/Linux:
```bash
sudo pnpm install
```

---

## 10. Preparando o banco de dados {#10-banco}

### O que vamos fazer aqui?
Vamos criar as "tabelas" no banco de dados — pense nelas como as planilhas onde cada tipo de informação vai ser guardado (uma tabela para usuários, uma para transações, etc.).

### Passo 1 — Verificar a conexão com o banco
```bash
pnpm db:studio
```
> 💡 *Isso abre uma interface visual para ver o banco de dados. Se abrir no navegador — a conexão está funcionando!*

Feche o studio (Ctrl+C no terminal) e continue.

### Passo 2 — Aplicar as migrations (criar as tabelas)
```bash
pnpm db:migrate
```
Você vai ver mensagens como:
```
Applying migration 0001_create_users_table...
Applying migration 0002_create_transactions_table...
✅ All migrations applied successfully
```

> 💡 *"Migration" é como um script que cria ou modifica as tabelas do banco. Cada migration é um passo na construção do banco.*

### Passo 3 — (Opcional) Preencher com dados de exemplo
Se quiser ver a aplicação com dados de exemplo para testar:
```bash
pnpm db:seed
```

### ✅ Como testar se funcionou?
```bash
pnpm db:studio
```
Abra no navegador e verifique se as tabelas aparecem no menu lateral.
Se aparecerem tabelas como `users`, `transactions`, etc. — funcionou! 🎉

---

## 11. Rodando a aplicação localmente {#11-rodando}

### O que significa "rodar localmente"?
Significa que a aplicação vai funcionar apenas no seu computador, no endereço `http://localhost:3000`. É como um ensaio geral antes de colocar no ar para todo mundo ver.

### Como rodar?
```bash
pnpm dev
```

Você vai ver algo como:
```
▲ Next.js 15.x
- Local:        http://localhost:3000
- Network:      http://192.168.x.x:3000

✓ Ready in 2.3s
```

### ✅ Como testar se funcionou?
1. Abra seu navegador (Chrome, Firefox, Safari...)
2. Digite na barra de endereço: `http://localhost:3000`
3. Aperte Enter
4. A aplicação deve aparecer! 🎉

> 💡 *Para parar a aplicação: volte ao terminal e aperte `Ctrl + C`*

---

## 12. Verificando se tudo está funcionando {#12-verificando}

### Checklist de verificação completo

Execute cada verificação e certifique-se de que tudo está ✅ antes de continuar:

```bash
# 1. TypeScript — verificar se o código está correto
pnpm typecheck
# ✅ Esperado: nenhuma mensagem de erro

# 2. Lint — verificar padrões de código
pnpm lint
# ✅ Esperado: "Checked X files. No errors found."

# 3. Testes — verificar se as funcionalidades estão corretas
pnpm test
# ✅ Esperado: "X passed" com todos os testes passando

# 4. Build — verificar se a aplicação compila corretamente
pnpm build
# ✅ Esperado: "✓ Compiled successfully"
```

> 💡 *Se algum desses comandos mostrar erro, veja a seção "O que fazer se algo der errado" (passo 14)*

---

## 13. Fazendo o deploy {#13-deploy}

### O que é deploy?
Deploy é colocar a aplicação no ar para que qualquer pessoa com acesso à internet possa usar. Vamos usar o Vercel para o site web e o EAS para o app mobile — ambos são gratuitos para começar.

### 13.1 Deploy do Front End Web (Vercel)

**Por que Vercel?** É o serviço mais simples para publicar aplicações Next.js. Tem plano gratuito, e a cada mudança no código ele atualiza automaticamente.

**Passo 1 — Criar conta no Vercel:**
1. Acesse https://vercel.com
2. Clique em "Sign Up"
3. Faça login com sua conta do GitHub (mais fácil)

**Passo 2 — Importar o projeto:**
1. No painel do Vercel, clique em "Add New → Project"
2. Escolha o repositório do GitHub que contém a aplicação
3. Clique em "Import"

**Passo 3 — Configurar as variáveis de ambiente:**
1. Antes de clicar em "Deploy", expanda a seção "Environment Variables"
2. Adicione todas as variáveis do seu `.env.local` (as mesmas do passo 8)
3. Cada variável: nome no campo "Key" e valor no campo "Value"

**Passo 4 — Fazer o deploy:**
1. Clique em "Deploy"
2. Aguarde 2–3 minutos
3. Quando aparecer "🎉 Congratulations!" — seu site está no ar!

**✅ Como testar:**
O Vercel vai mostrar a URL do seu site (algo como `https://ecp-bank.vercel.app`).
Abra no navegador — deve funcionar igualzinho ao `localhost:3000`!

---

### 13.2 Deploy do App Mobile (EAS)

**Por que EAS?** É o serviço oficial do Expo para compilar e publicar apps React Native para iOS e Android.

**Passo 1 — Instalar o EAS CLI:**
```bash
npm install -g eas-cli
```

**Passo 2 — Fazer login no Expo:**
```bash
eas login
```
> Se não tiver conta, crie em: https://expo.dev

**Passo 3 — Configurar o projeto:**
```bash
cd apps/mobile
eas build:configure
```

**Passo 4 — Compilar para Android (APK para testar):**
```bash
eas build --platform android --profile preview
```
> 💡 *"preview" gera um APK que pode ser instalado diretamente no celular Android para testes, sem precisar da Play Store. Leva 5–15 minutos.*

**Passo 5 — Instalar no celular:**
1. O EAS vai mostrar um QR Code e um link quando terminar
2. No celular Android, abra o link
3. Baixe e instale o APK
4. Pronto — o app está no seu celular! 🎉

> ⚠️ *Para publicar na App Store (iOS) ou Play Store (Android), são necessárias contas de desenvolvedor pagas ($99/ano Apple, $25 Google). Para testar, o profile "preview" é suficiente.*

---

## 14. O que fazer se algo der errado {#14-erros}

### Erros mais comuns e como resolver

---

**❌ "command not found: node"**
- **O que significa:** O Node.js não foi instalado corretamente
- **Solução:** Desinstale e instale novamente pelo site https://nodejs.org. Após instalar, feche e abra o terminal de novo.

---

**❌ "command not found: pnpm"**
- **O que significa:** O pnpm não foi instalado ou o terminal não reconheceu
- **Solução:**
  ```bash
  npm install -g pnpm
  ```
  Feche e abra o terminal. Tente novamente.

---

**❌ "Error: Cannot find module..."**
- **O que significa:** As dependências não foram instaladas
- **Solução:**
  ```bash
  pnpm install
  ```

---

**❌ "Error connecting to database" ou "Connection refused"**
- **O que significa:** A aplicação não conseguiu se conectar ao banco de dados
- **Solução:**
  1. Verifique se as variáveis `DATABASE_URL` e `NEXT_PUBLIC_SUPABASE_URL` estão corretas no `.env.local`
  2. Abra o painel do Supabase e verifique se o projeto está ativo
  3. Verifique se a senha na URL do banco está correta (sem caracteres especiais sem codificação)

---

**❌ "Invalid API key" ou "Unauthorized"**
- **O que significa:** Uma chave de API está incorreta
- **Solução:**
  1. Volte ao painel do Supabase e copie as chaves novamente
  2. Certifique-se de não ter espaços extras ao colar no `.env.local`
  3. Reinicie o servidor com `pnpm dev`

---

**❌ "Port 3000 is already in use"**
- **O que significa:** Já tem um servidor rodando na porta 3000
- **Solução:**
  ```bash
  # No Mac/Linux — matar o processo na porta 3000
  kill -9 $(lsof -ti:3000)

  # No Windows
  netstat -ano | findstr :3000
  taskkill /PID [número-que-apareceu] /F
  ```
  Depois tente `pnpm dev` novamente.

---

**❌ Erro no TypeScript ("Type error: ...")**
- **O que significa:** Há um erro de código que precisa ser corrigido
- **Solução:** Leia a mensagem de erro — ela indica o arquivo e a linha exata do problema. Se não entender, copie a mensagem completa e pesquise no Google ou pergunte ao ChatGPT.

---

**❌ Build falhou no Vercel**
- **O que significa:** A aplicação não compilou na nuvem
- **Solução:**
  1. Verifique se todas as variáveis de ambiente foram adicionadas no Vercel (passo 13.1)
  2. Certifique-se de que `pnpm build` funciona localmente antes de fazer deploy
  3. Veja os logs detalhados na aba "Deployments" do Vercel

---

### Ainda com problemas?

Se nenhuma das soluções acima resolver:

1. **Leia a mensagem de erro completa** — geralmente ela diz exatamente o que está errado
2. **Copie a mensagem de erro** e pesquise no Google — você provavelmente não é o primeiro com esse problema
3. **Verifique a versão do Node.js** — deve ser 20 ou superior (`node --version`)
4. **Delete a pasta de dependências e reinstale:**
   ```bash
   rm -rf node_modules
   pnpm install
   ```
5. **Delete o cache do pnpm:**
   ```bash
   pnpm store prune
   pnpm install
   ```

---

## 🎉 Parabéns!

Se você chegou até aqui e tudo está funcionando — você instalou uma aplicação full-stack completa com banco de dados, cache, autenticação e deploy na nuvem!

Isso é algo que muitos desenvolvedores profissionais levam anos para aprender a fazer. Você conseguiu seguindo os passos com atenção.

### Próximos passos sugeridos
- Explorar a aplicação e entender como cada parte funciona
- Ler a documentação funcional em `docs/funcional/` para entender as regras de negócio
- Contribuir com melhorias no código

---

*Guia gerado automaticamente pelo ECP AI Squad — Operations Agent*
*Data de geração: [data]*
*Versão da aplicação: [versão]*
```

---

## Instruções para o Agente

### O que personalizar ao gerar este guia
O agente deve substituir todas as partes entre `[colchetes]` com as informações reais do projeto:
- Nome da aplicação
- URL do repositório no GitHub
- Lista real de variáveis de ambiente do `.env.example`
- Serviços reais utilizados (se diferente do padrão do framework)
- Comandos específicos do projeto (se diferentes dos padrões)
- Tabela de partes da aplicação adaptada à stack real

### O que NÃO omitir
- Nenhum serviço externo necessário pode ficar fora do guia
- Nenhuma variável de ambiente pode ficar sem explicação
- Nenhum passo pode ser pulado mesmo que pareça "óbvio"
- Todos os erros comuns do stack devem estar na seção de troubleshooting

### Atualizar se a stack mudar
Se o projeto usar serviços além do padrão do framework (ex: Stripe, SendGrid, Twilio), adicionar uma seção específica para cada serviço entre os passos 6 e 8, seguindo o mesmo padrão: o que é → por que precisa → como configurar → como testar.

## Output
```json
{
  "agent": "operations",
  "skill": "installation-guide-writer",
  "output": "{REPO_DESTINO}/docs/INSTALACAO.md",
  "also_included_in": "{REPO_DESTINO}/docs/instalacao.html",
  "sections": 14,
  "services_documented": [],
  "estimated_install_time_minutes": 45
}
```
