# Skill: component-spec

## Objetivo
Especificar componentes o produto (conforme design_spec.md) para todas as plataformas.
Referência visual: `{REPO_DESTINO}/design_spec.md (protótipo de referência)`, `prototipo-referencia-android.html`, `prototipo-referencia-ios.html`.

---

## WEB — shadcn/ui customizado

### Botões
```
Primary:   bg=#b7ff2a  text=#0b0f14  hover=#9eea12  radius=pill  h=44px
Secondary: bg=transparent  border=#27364a  text=#eaf2ff  hover-bg=#131c28
Ghost:     bg=transparent  text=#eaf2ff  hover-bg=#0f1620
```

### Cards
```
bg=#131c28  border=#1c2836  radius=18px  shadow=ecp-sm
card-head: título + ação secundária  p=20px
card-body: conteúdo  p=20px pt=0
card-foot: CTAs  p=16px  border-top=#1c2836
```

### Sidebar (Desktop)
```
width=280px  bg=#0b0f14  border-right=#1c2836
Item h=44px  radius=10px  px=12px
Estado ativo: border-left=3px solid #b7ff2a  bg=#0f1620  text=#b7ff2a
Logo: Inter 700  tracking=0.2px
```

### Topbar
```
height=64px  bg=rgba(11,15,20,0.75)  backdrop-blur=10px  border-bottom=#1c2836
Sticky no topo  z-index=20
```

### Tabela (Extrato)
```
Header: bg=#0f1620  text=#7b8aa3  font-size=12px uppercase
Linhas: border-bottom=#1c2836  hover-bg=#0f1620
Valor positivo: #3dff8b  negativo: #ff4d4d
font-variant-numeric: tabular-nums
```

### Drawer (Detalhe)
```
Posição: lateral direita  width=400px
bg=#131c28  border-left=#27364a  shadow=ecp-lg
Overlay: rgba(11,15,20,0.80)
```

### Tabs (Pill)
```
Container: bg=#0f1620  radius=pill  p=4px
Tab ativo: bg=#b7ff2a  text=#0b0f14  radius=pill
Tab inativo: text=#7b8aa3
```

### Focus Ring
```
box-shadow: 0 0 0 4px rgba(183,255,42,0.20)
Aplicar em todo elemento interativo via :focus-visible
```

---

## ANDROID — React Native + NativeWind

### Top App Bar
```
h=56  bg=rgba(11,15,20,0.78)  backdrop: blurView
Título: Inter 700  text=#eaf2ff
Ícones à direita: privacidade + notificações
```

### Bottom Navigation
```
h=72 (+ safe area)  bg=rgba(18,27,39,0.92)  border-top=rgba(39,54,74,0.30)
5 itens: Home | Extrato | Pix | Cartões | Perfil
Ativo: ícone + label em #b7ff2a
```

### Cards
```
bg=#121b27  border=rgba(39,54,74,0.45)  radius=18  p=16
Shadow: 0 14px 40px rgba(0,0,0,0.38)
```

### Quick Actions (Grid 4 colunas)
```
Container ícone: bg=rgba(183,255,42,0.12)  radius=14  p=12
Ícone: #b7ff2a  Label: Inter 12 600  text=#a9b7cc
Min touch target: 48dp
```

### Bottom Sheet (Detalhe)
```
bg=#131c28  radius topo=24  grab handle: bg=#27364a  w=40 h=4
Header: título + close button
Metadados em linhas com border-bottom sutil
CTAs na base: Primary lime + Secondary outline
```

---

## iOS — React Native + Expo

### Tab Bar
```
5 itens: Home | Extrato | Pix | Cartões | Perfil
bg: translúcido sistema  tintColor=#b7ff2a
Min touch target: 44pt
```

### Navigation Bar
```
Large title em telas principais
bg: comportamento nativo do sistema
Ações à direita: privacidade + notificações
```

### Cards
```
bg=#131c28  radius=18  p=16  separator sutil
Preferir listas grouped para extrato
```

### Sheet (Detalhe)
```
Sheet nativo iOS (não drawer lateral)
Header + close  Metadados  CTAs: primary lime + secondary outline
```

### Segmented Control (Pix)
```
Segmentos: Enviar | Receber | Chaves
Estilo nativo iOS customizado com tint lime
```

### Valores financeiros
```
fontFeatureSettings: "tnum"  (monospacedDigit)
Positivo: #3dff8b  Negativo: #ff4d4d
```
