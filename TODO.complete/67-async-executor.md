# 67 — Async function support in the rule executor

**Status:** TODO
**Priority:** P0 (required by rababa/secryst integration)

## Problem

The current rule executor's `funcall` handler calls functions
synchronously. ML functions (`rababa`, `secryst`) are inherently async
because they invoke ONNX inference. We need either:

1. **Async execution path** for stages that contain ML calls
2. **Sync wrapper** that pre-loads models + blocks (Node only, won't work in browser)

Option 1 is correct. Option 2 is a non-starter for the website.

## Design

The interpreter's `executeStage` becomes async-aware:
- If a stage contains any `funcall` rule whose target is async, execute
  the whole stage via `executeStageAsync`
- Sync stages stay sync for performance (the 99% case)
- The runtime decides which path based on a quick check

## Public API

```typescript
transliterate(systemCode, input)              // sync; throws if map needs ML
transliterateAsync(systemCode, input)          // async; works for everything
```

Already have `transliterateAsync` — just need to make the executor
itself async when ML is involved.

## Acceptance

- [ ] `executeStageAsync` exists alongside `executeStage`
- [ ] Stage inspection detects ML funcalls without running them
- [ ] All existing sync tests still pass
- [ ] New tests cover async execution paths
