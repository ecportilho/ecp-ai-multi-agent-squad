# Skill — feature-flags-manager

## Objetivo
Gerenciar feature flags para A/B testing e rollout gradual no o produto.

## Arquivo de Feature Flags
```json
// config/features.json
{
  "ab_tests": {
    "board_layout_v2": {
      "enabled": true,
      "variants": {
        "A": { "weight": 50, "description": "Layout atual" },
        "B": { "weight": 50, "description": "Novo layout com sidebar" }
      },
      "metrics": ["time_on_board", "cards_created", "session_duration"]
    }
  },
  "features": {
    "card_labels": true,
    "due_dates": true,
    "card_comments": false
  }
}
```

## Middleware de A/B
```javascript
// utils/abTest.js
const features = require('../config/features.json');

const getVariant = (testName, userId) => {
  const test = features.ab_tests[testName];
  if (!test || !test.enabled) return 'A';
  // Determinístico por userId
  const hash = userId.split('').reduce((a, c) => a + c.charCodeAt(0), 0);
  return hash % 100 < test.variants.A.weight ? 'A' : 'B';
};

module.exports = { getVariant };
```
