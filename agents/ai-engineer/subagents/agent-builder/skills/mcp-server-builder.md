---
name: mcp-server-builder
description: Construir MCP (Model Context Protocol) servers que expõem ferramentas para agentes de IA. Acionar quando precisar criar um servidor MCP, expor APIs internas como tools para um agente, implementar transporte stdio ou HTTP/SSE para MCP, ou integrar um agente com sistemas externos via MCP. Inclui definição de resources, tools e prompts no protocolo MCP.
---

# MCP Server Builder

## O que faz
Constrói MCP servers que permitem agentes de IA acessar sistemas externos de forma padronizada. O MCP é o protocolo que conecta LLMs a ferramentas do mundo real.

## Estrutura de um MCP Server

### Setup com TypeScript
```typescript
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new McpServer({
  name: 'ecp-bank-mcp',
  version: '1.0.0',
});

// Definir uma tool
server.tool(
  'get_balance',
  'Consultar saldo da conta do usuário',
  {
    account_id: { type: 'string', description: 'ID da conta bancária' }
  },
  async ({ account_id }) => {
    const balance = await bankApi.getBalance(account_id);
    return {
      content: [{ type: 'text', text: `Saldo: R$ ${balance.amount}` }]
    };
  }
);

// Definir um resource
server.resource(
  'account://info',
  'Informações gerais da conta',
  async (uri) => {
    const info = await bankApi.getAccountInfo(uri.params.id);
    return {
      contents: [{ uri: uri.href, mimeType: 'application/json', text: JSON.stringify(info) }]
    };
  }
);

// Iniciar servidor
const transport = new StdioServerTransport();
await server.connect(transport);
```

## Regras de Segurança
- Cada tool deve ter escopo mínimo — uma tool = uma ação
- Tools de leitura e escrita são separadas (nunca uma tool que "lê e atualiza")
- Inputs sempre validados com schema antes de execução
- Erros retornados como `isError: true` — nunca throw que mate o server
- Logs de todas as invocações (tool name, params sanitizados, duração, status)

## Transportes
| Transporte | Quando Usar |
|-----------|-------------|
| stdio | Agente e server no mesmo ambiente (local, CLI) |
| HTTP+SSE | Server remoto, múltiplos clientes, produção |

## Output
MCP server funcional com tools definidas, validação de input e error handling.
