# 92 — Migrate compileItem to registry pattern

**Status:** P2 (code quality)
**Depends on:** none

## Problem

`src/runtime/compile-item.ts:compileItem` uses a single switch over
Item.kind. Adding a new Item kind requires editing this switch — a
violation of OCP.

## Fix

Replace the switch with a registry:

```typescript
type ItemCompiler = (item: Item, ctx: ExecutionContext) => CompiledItem

const itemCompilers = new Map<Item["kind"], ItemCompiler>()

export function registerItemCompiler(kind: Item["kind"], compiler: ItemCompiler): void {
  itemCompilers.set(kind, compiler)
}

export function compileItem(item: Item, ctx: ExecutionContext): CompiledItem {
  const compiler = itemCompilers.get(item.kind)
  if (!compiler) throw new Error(`No compiler for Item kind: ${item.kind}`)
  return compiler(item, ctx)
}
```

Similarly for `compileToLiteral` and `expandFromLiterals`.

## Acceptance

- [ ] No switch statements on Item.kind anywhere
- [ ] Adding a new Item kind = new file, zero edits
- [ ] All existing tests pass unchanged
- [ ] Type system still enforces exhaustiveness
