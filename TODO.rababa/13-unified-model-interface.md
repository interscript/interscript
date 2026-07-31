# rababa-v2: 13 — Unified model interface for interscript-ts

**Status:** SPECIFICATION
**Priority:** P0

## Goal

One TypeScript interface for ALL ML models. The runtime doesn't know
or care whether a model is rababa, secryst, ByT5, or a distilled student.
It calls `model.transform(input)` and gets output back.

## Current state

```
RababaModel.diacritize(text) → string
SecrystModel.translate(text) → string
```

Two different method names for the same concept. Should be unified.

## Unified interface

```typescript
// src/ml/types.ts
export interface MLModel extends Model {
  /** Transform input text → output text. The universal method. */
  transform(input: string): Promise<string>
}
```

Both RababaModel and SecrystModel implement `transform`:

```typescript
// Rababa
class RababaModelImpl implements MLModel {
  async transform(input: string): Promise<string> {
    return this.diacritize(input)  // delegates to existing method
  }
}

// Secryst
class SecrystModelImpl implements MLModel {
  async transform(input: string): Promise<string> {
    // Process line by line, matching Ruby behavior
    const lines = input.split("\n")
    const results: string[] = []
    for (const line of lines) {
      results.push(await this.translate(line))
    }
    return results.join("\n")
  }
}
```

## Interpreter integration

The async funcall handler doesn't need to know which model it's calling:

```typescript
// src/runtime/interpreter.ts
async function executeFuncallAsync(rule, ctx) {
  if (ASYNC_FUNCTIONS.has(rule.name)) {
    const { loadModel } = await import("../ml/index.js")
    const model = await loadModel({
      kind: rule.name,  // "rababa" or "secryst"
      id: rule.kwargs?.config ?? rule.kwargs?.model ?? "default",
    }) as MLModel
    ctx.current = await model.transform(ctx.current)
    return
  }
  // ... sync fallback
}
```

**OCP**: adding a new ML function = registering it in `ASYNC_FUNCTIONS`
+ having its model implement `MLModel.transform`. The interpreter
never changes.

**MECE**: the interpreter knows about `ASYNC_FUNCTIONS` and `MLModel.transform`.
It does NOT know about Arabic diacritization, Thai transliteration, or
any model-specific details.

## Acceptance

- [ ] `MLModel.transform(input)` defined in types
- [ ] RababaModel implements transform (delegates to diacritize)
- [ ] SecrystModel implements transform (line-by-line translate)
- [ ] Interpreter uses unified interface (no per-model branching)
- [ ] Specs verify both models satisfy MLModel
