# Skill: state-management

## Objetivo
Gerenciar estado com TanStack Query via tRPC hooks — sem useState para dados do servidor.

## Padrão de Data Fetching
```tsx
"use client";
import { trpc } from "@/lib/trpc";

// ✅ Query (leitura)
export function ResourceList() {
  const { data, isLoading, error } = trpc.resource.list.useQuery({
    limit: 20,
  });

  if (isLoading) return <Skeleton />;
  if (error) return <ErrorMessage message={error.message} />;

  return <ul>{data?.items.map(r => <ResourceItem key={r.id} resource={r} />)}</ul>;
}

// ✅ Mutation (escrita) com invalidação de cache
export function CreateResourceForm() {
  const utils = trpc.useUtils();

  const createResource = trpc.resource.create.useMutation({
    onSuccess: () => {
      utils.resource.list.invalidate(); // revalida a lista após criar
    },
  });

  const handleSubmit = (data: CreateResourceInput) => {
    createResource.mutate(data);
  };
}

// ✅ Infinite query (scroll infinito com cursor-based pagination)
export function InfiniteResourceList() {
  const { data, fetchNextPage, hasNextPage } = trpc.resource.list.useInfiniteQuery(
    { limit: 20 },
    { getNextPageParam: (lastPage) => lastPage.nextCursor },
  );
}
```

## Estado Local (UI apenas)
```tsx
// useState APENAS para estado de UI — nunca para dados do servidor
const [isOpen, setIsOpen] = useState(false);
const [activeTab, setActiveTab] = useState("overview");
```

## Regras
- NUNCA `useEffect` para data fetching
- NUNCA `useState` para dados do servidor
- NUNCA `fetch()` direto — sempre tRPC hooks
- SEMPRE invalidar cache após mutations relevantes
