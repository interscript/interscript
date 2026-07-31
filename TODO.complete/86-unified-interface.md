# 86 — Unified transliterateAsync (single interface)

**Status:** P0 (the core goal)
**Depends on:** #85 (async executor)

## Goal

**`transliterateAsync(systemCode, input)`** is the single entry point
for ALL transliteration — rule-based and ML-powered. Users don't need
to know which path their map takes. The runtime detects and routes
automatically.

## API surface

```typescript
// Universal — works for everything
import { transliterateAsync } from "interscript-ts"
const result = await transliterateAsync("var-ara-Arab-Arab-rababa", "قطر")
// → "قِطْرَ"

// Sync — works for everything except ML maps
import { transliterate } from "interscript-ts"
const result = transliterate("bgnpcgn-ukr-Cyrl-Latn-2019", "Антон")
// → "Anton"

// Sync on ML map → clear error
transliterate("var-ara-Arab-Arab-rababa", "قطر")
// → Error: "This map requires async execution. Use transliterateAsync()."
```

## Error handling (fallback strategy)

If onnxruntime isn't installed:
```
Error: "ML inference requires onnxruntime-node. Install: npm install onnxruntime-node"
```

If model can't be loaded (network failure, missing file):
```
Error: "Failed to load model rababa/200 from https://huggingface.co/...: 404"
```

## Acceptance

- [ ] `transliterateAsync` works for every map in the catalogue
- [ ] `transliterate` throws a clear error for ML maps
- [ ] Model loading is lazy (only when an ML map is requested)
- [ ] Fallback errors include actionable install instructions
