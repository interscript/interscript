# 68 — Code quality audit (OCP / MECE / DRY)

**Status:** TODO
**Priority:** P1

## Find current violations

### interscript-ts

- `runtime/compile-item.ts:compileItem` — single switch over Item kind.
  Adding a new Item kind requires editing this switch.
  **Fix**: registry pattern (`itemCompilers: Record<ItemKind, Compiler>`).
- `runtime/executor.ts:executors` — already a registry ✓
- `stdlib.ts` — switch in `parallelSinglePass` (removed); remaining
  functions are dispatch-table-driven ✓

### interscript.org

- `src/scripts/api-playground.ts` — large procedural script with
  inline rendering. **Fix**: extract `PlaygroundState`,
  `PlaygroundView`, `PlaygroundController` (MVC).
- `src/components/MapCatalogue.vue` — 400+ lines; mix of state,
  presentation, filtering logic. **Fix**: extract `useCatalogueFilter`
  composable.
- `src/pages/api-docs.astro` — hand-built; should be generated from
  the OpenAPI spec to stay in sync. **Fix**: generate from
  `/openapi.json` at build time.

### interscript-ruby

- `lib/interscript/compiler/json_ir.rb:serialise_item` — switch over
  Item class. Ruby's case/when is more idiomatic here but still
  violates OCP for new Item types.
  **Fix**: each Item class implements `to_ir` (visitor pattern).

## Acceptance

- [ ] Audit report committed listing every violation + proposed fix
- [ ] Top 3 violations fixed
- [ ] Spec coverage ≥ 90% on refactored modules
