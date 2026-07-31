# 85 — Async executor for ML funcalls

**Status:** P0 (blocks all ML integration)
**Depends on:** #61 (ML abstraction layer) — DONE

## Problem

The current rule executor is synchronous. The `funcall` handler calls
functions like `compose(input)` and expects a string back immediately.
But `rababa(input)` returns `Promise<string>` because it invokes ONNX
inference.

If a map's stage contains a `rababa` funcall, the sync executor silently
assigns a Promise to `ctx.current`, and the next rule sees `[object Promise]`
instead of the diacritized text.

## Design

**Detect async at stage entry, route to async path.** Two-stage approach
keeps the hot path (99% of maps) fully synchronous:

```typescript
const ASYNC_FUNCTIONS = new Set(["rababa", "secryst"])

function stageContainsAsyncFuncalls(rules: Rule[]): boolean {
  for (const r of rules) {
    if (r.kind === "funcall" && ASYNC_FUNCTIONS.has(r.name)) return true
    if ((r.kind === "parallel" || r.kind === "sequential") &&
        r.rules.some(inner => inner.kind === "funcall" && ASYNC_FUNCTIONS.has(inner.name))) {
      return true
    }
  }
  return false
}

export function executeStage(...): string {
  if (stageContainsAsyncFuncalls(stage.rules)) {
    throw new Error("Stage contains async functions (rababa/secryst). Use transliterateAsync().")
  }
  // existing sync path — unchanged
}

export async function executeStageAsync(...): Promise<string> {
  if (!stageContainsAsyncFuncalls(stage.rules)) {
    return executeStage(...)  // fast sync path
  }
  // async path: same executor but funcall handler awaits
}
```

**OCP**: adding a new async function = adding to the `ASYNC_FUNCTIONS`
set. The set is generated from the ML module's registered functions.

**Performance**: sync maps have zero overhead. Async maps pay only for
the `await` keyword at the funcall site (~0.01ms per call).

## Acceptance

- [ ] `executeStageAsync` exists and handles rababa/secryst funcalls
- [ ] `executeStage` throws clear error for ML stages
- [ ] Sync maps run through the fast path with zero overhead
- [ ] Specs cover both paths + the detection logic
