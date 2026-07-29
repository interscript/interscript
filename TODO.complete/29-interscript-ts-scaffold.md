# 29 — `interscript-ts` initial scaffold

**Status:** DONE — initial scaffold published

## What was created
New repo: https://github.com/interscript/interscript-ts

### Architecture (per OCP / MECE / DRY)
| Module | Responsibility |
|--------|----------------|
| `src/types.ts` | Domain model — discriminated unions for AST nodes (Stage, Rule variants, Item variants) |
| `src/errors.ts` | Typed error hierarchy (InterscriptError → MapNotFoundError, SystemConversionError, MapLogicError, DependencyMissingError) |
| `src/stdlib.ts` | Pure helpers ported from Ruby (parallelReplace, regexpEscape, titleCase, separate, downcase, upcase, compose, decompose) |
| `src/loader.ts` | Strategy-pattern map loader — new sources added via `LoadStrategy` array (OCP) |
| `src/runtime/context.ts` | ExecutionContext — pure data carrier, holds current string + alias cache |
| `src/runtime/compile-item.ts` | Item → RegExp/literal compiler (exhaustive switch on `kind`) |
| `src/runtime/executor.ts` | Rule executors in a registry — new rule kinds added without modifying existing (OCP) |
| `src/runtime/interpreter.ts` | Stage runner — pure orchestrator |
| `src/index.ts` | Public API (transliterate, loadMap, detect, configure) |

### Public API (mirrors Ruby)
```typescript
transliterate(systemCode, input, stage?) → string
loadMap(systemCode) → CompiledMap
detect(input, output, opts?) → DetectionResult[]  // deferred
configure({ strategies, defaultStage }) → void
```

### Tooling
- TypeScript 5.6 (typescript-eslint lacks TS 7 support as of 2026-07)
- Vitest 4 (modern test runner)
- ESLint 10 + typescript-eslint 8 + Prettier 3
- ESM-first (`"type": "module"`)
- Node 20+ engine

### Tests
- 21 unit tests passing (stdlib + interpreter + executeRule + item compilation)
- Parity test infrastructure (test/parity.test.ts) ready for Ruby-generated fixtures
- Ruby fixture generator (scripts/gen-parity-fixtures.rb)

### CI/Release
- ci.yml: build + test + lint + coverage on Node 20/22
- release.yml: npm publish --provenance on tag push
- codeql.yml: weekly TypeScript analysis
- Dependabot: actions + npm weekly

## Verification
- `npm run build` ✓
- `npm test` ✓ (21/22 pass, 1 skipped — parity needs fixtures)
- `npm run lint` ✓
- `npm run format:check` ✓

## First release
v0.1.0 ready to publish. Tag once reviewed.
