# 47 — HTTP strategy for interscript-ts

**Status:** DEFERRED — needed for browser use

## Why
`src/loaders.ts` has `filesystemStrategy` (Node-only) and `bundledStrategy` (build-time). For browser use cases that want to load maps on demand, we need an HTTP strategy.

## API
```typescript
import { httpStrategy } from "interscript-ts/loaders"

const strat = httpStrategy({
  baseUrl: "https://interscript.org/maps/",
  // or CDN: "https://unpkg.com/interscript-maps-ir@latest/"
})
```

## Implementation notes
- Use `fetch()` (native in Node 20+ and browsers)
- Cache responses in memory (the loader already does this)
- Handle 404 → return undefined (so other strategies can try)
- Support custom headers (for auth, caching)

## Files
- `src/loaders.ts`: add `httpStrategy` function
- `test/loader.test.ts`: mock fetch tests

## Effort
S
