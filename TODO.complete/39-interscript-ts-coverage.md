# 39 — Spec coverage baseline for interscript-ts

**Status:** ONGOING

## Current coverage
21 unit tests passing across:
- `src/stdlib.ts` (10 tests): parallelReplace, regexpEscape, titleCase, separate, downcase/upcase, compose/decompose
- `src/index.ts` + interpreter (11 tests): transliterate variants, executeRule for sub/run/funcall, item compilation (string/any/alias), error cases

## Gaps
| Area | Gap | Priority |
|------|-----|----------|
| `compileItem` | `repeat`, `group` not covered | High |
| `executor` `sub` rule | `before`, `after`, `notBefore`, `notAfter` not covered | High |
| `ExecutionContext` | `resolveAlias` cache behavior untested | Medium |
| `MapLoader` | Multi-strategy priority, caching | High |
| `detect` | Not implemented yet (TODO 32) | — |
| Parity tests | Need Ruby fixtures (TODO 31) | — |

## Plan
1. Add tests for `compileItem` repeat/group (S)
2. Add tests for `sub` rule with positional context (S)
3. Add `MapLoader` tests for strategy priority + cache (M)
4. Generate Ruby parity fixtures once TODO 31 lands
5. Target 90% coverage before v0.2.0

## Coverage gate
Once baseline established, add to `vitest.config.ts`:
```typescript
coverage: {
  thresholds: {
    lines: 90,
    functions: 90,
    branches: 85,
  },
},
```
CI fails below threshold.
