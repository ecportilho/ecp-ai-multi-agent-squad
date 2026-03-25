---
name: mobile-identity
description: >
  Aplicar identidade visual do design_spec.md em componentes Expo/React Native com NativeWind. Use ao implementar componentes mobile — garantindo consistência com a identidade web.
---

# Skill: mobile-identity

## Objetivo
Implementar a identidade visual o produto (conforme design_spec.md) no app mobile Expo (React Native + NativeWind).

## Identidade Visual (OBRIGATÓRIO — ler antes de implementar)
- `{REPO_DESTINO}/design_spec.md`
- `{REPO_DESTINO}/design_spec.md`
- `{REPO_DESTINO}/design_spec.md (protótipo de referência)`
- `{REPO_DESTINO}/design_spec.md (protótipo de referência)`

## Tokens Compartilhados
Importar de `packages/shared/src/constants/tokens.android.ts` e `tokens.ios.ts`.
Gerados pelo UI Agent na skill `design-tokens`.

## Configuração NativeWind

### tailwind.config.js (apps/mobile)
```javascript
module.exports = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        "ecp-bg": "#0b0f14",
        "ecp-surface": "#121b27",
        "ecp-surface-2": "#0f1620",
        "ecp-text": "#eaf2ff",
        "ecp-text-secondary": "#a9b7cc",
        "ecp-muted": "#7b8aa3",
        "ecp-lime": "#b7ff2a",
        "ecp-lime-pressed": "#7ed100",
        "ecp-success": "#3dff8b",
        "ecp-danger": "#ff4d4d",
        "ecp-warning": "#ffcc00",
        "ecp-info": "#4da3ff",
      },
      borderRadius: {
        card: "18px",
        control: "14px",
        pill: "999px",
      },
    },
  },
  plugins: [],
};
```

## Componentes Mobile

### Bottom Navigation (Android)
```tsx
// apps/mobile/components/layout/bottom-nav.tsx
import { View, TouchableOpacity, Text } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";

const TABS = [
  { label: "Home", icon: "home" },
  { label: "Extrato", icon: "list" },
  { label: "Pix", icon: "zap" },
  { label: "Cartões", icon: "credit-card" },
  { label: "Perfil", icon: "user" },
];

export function BottomNav({ activeTab }: { activeTab: string }) {
  const insets = useSafeAreaInsets();
  return (
    <View
      className="flex-row bg-ecp-surface border-t border-ecp-bg"
      style={{ paddingBottom: insets.bottom }}
    >
      {TABS.map((tab) => (
        <TouchableOpacity key={tab.label} className="flex-1 items-center py-3 min-h-[48px]">
          {/* ícone */}
          <Text className={activeTab === tab.label ? "text-ecp-lime text-xs mt-1" : "text-ecp-muted text-xs mt-1"}>
            {tab.label}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}
```

### Card (Android/iOS)
```tsx
<View className="bg-ecp-surface rounded-card p-4 mb-3 border border-ecp-bg">
  {children}
</View>
```

### Valor financeiro (tabular-nums)
```tsx
// Positivo
<Text className="text-ecp-success font-bold" style={{ fontVariant: ["tabular-nums"] }}>
  +R$ 1.000,00
</Text>

// Negativo
<Text className="text-ecp-danger font-bold" style={{ fontVariant: ["tabular-nums"] }}>
  -R$ 500,00
</Text>
```

### Botão Primary (lime)
```tsx
<TouchableOpacity className="bg-ecp-lime rounded-pill h-[52px] items-center justify-center px-6 active:bg-[#7ed100]">
  <Text className="text-ecp-bg font-bold text-base">Confirmar</Text>
</TouchableOpacity>
```

## Checklist de Fidelidade Mobile
- [ ] Tokens importados de packages/shared
- [ ] Background sempre dark `#0b0f14`
- [ ] Bottom nav com 5 itens, ativo em lime
- [ ] Cards com radius=18 e border sutil
- [ ] Touch targets >= 48dp (Android) / 44pt (iOS)
- [ ] Valores com fontVariant: tabular-nums
- [ ] Safe area respeitada (useSafeAreaInsets)
- [ ] Fonte Inter (ou sistema nativo no iOS)
