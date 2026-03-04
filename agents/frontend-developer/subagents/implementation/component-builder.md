# Skill: component-builder

## Objetivo
Construir componentes reutilizáveis em Next.js 15 com shadcn/ui e Tailwind CSS.

## Padrão de Componente
```tsx
// apps/web/src/components/domain/resource-card.tsx
// ✅ Named export, interface de props, Tailwind CSS, shadcn/ui

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

interface ResourceCardProps {
  title: string;
  status: "ACTIVE" | "INACTIVE";
  amountCents: number;
}

export function ResourceCard({ title, status, amountCents }: ResourceCardProps) {
  const formattedAmount = new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL",
  }).format(amountCents / 100);   // ← centavos para reais

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between pb-2">
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
        <Badge variant={status === "ACTIVE" ? "default" : "secondary"}>
          {status}
        </Badge>
      </CardHeader>
      <CardContent>
        <p className="text-2xl font-bold">{formattedAmount}</p>
      </CardContent>
    </Card>
  );
}
```

## Adicionar componente shadcn/ui
```bash
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add form
npx shadcn@latest add dialog
```

## Server Component vs Client Component
```tsx
// ✅ Server Component (default) — sem "use client"
// Pode fazer fetch diretamente, acessa cookies/headers
export async function ResourceList() {
  const caller = createCaller(await createContext());
  const data = await caller.resource.list({ limit: 20 });
  return <ul>{data.items.map(r => <ResourceCard key={r.id} {...r} />)}</ul>;
}

// ✅ Client Component — apenas com hooks ou eventos
"use client";
export function ResourceForm() {
  const createResource = trpc.resource.create.useMutation();
  // ...
}
```

## Regras
- Componentes > 150 linhas → quebrar em sub-componentes
- Props > 5 → considerar objeto ou sub-componentes
- NUNCA `React.FC`
- NUNCA `default export` (exceto page.tsx e layout.tsx)

## Identidade Visual o produto (conforme design_spec.md)
Sempre seguir: `{REPO_DESTINO}/design_spec.md` e `prototipo-referencia-web.html`.

### Cores Tailwind customizadas disponíveis
```
text-ecp-text / text-ecp-text-secondary / text-ecp-text-muted
bg-ecp-bg / bg-ecp-surface / bg-ecp-surface-2
border-ecp-border / border-ecp-border-subtle
text-ecp-lime / bg-ecp-lime
text-ecp-success / text-ecp-danger / text-ecp-warning / text-ecp-info
shadow-ecp-sm / shadow-ecp-md / shadow-ecp-lime
```

### Regras de identidade no código
- NUNCA usar `#ffffff` como cor de fundo — sempre dark `#0b0f14`
- NUNCA inventar cores — usar apenas as definidas nos tokens
- SEMPRE `tabular-nums` em valores financeiros
- SEMPRE lime `#b7ff2a` para CTAs primários
- Fonte: Inter via `next/font/google`
