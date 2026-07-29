# 24 — TypeScript runtime port for `interscript-js` (Phase C2)

**Status:** DEFERRED — multi-day effort

## Why
- Replace the legacy Opal bundle path (`interscript.js`, 26k lines, untracked locally)
- Native TS port of Ruby `Interscript::Interpreter` semantics
- Maps stay Ruby DSL; only the runtime becomes TS

## Scope (from main plan)
- Port `interscript-ruby/lib/interscript/interpreter.rb` (~255 LOC) → TS
- Port `interscript-ruby/lib/interscript/stdlib.rb` (~269 LOC) → TS
- Port `interscript-ruby/lib/interscript/compiler/javascript.rb` runtime contract → TS
- TS scaffold: `tsconfig.json`, `src/index.ts`, `src/stdlib.ts`, etc.
- Generate Ruby-parity test fixtures (`scripts/gen-parity-fixtures.rb`)
- Remove `interscript.js` (Opal bundle) entirely
- CI: build TS, then test

## Reference sources (read-only)
- `interscript-ruby/lib/interscript.rb` — public API
- `interscript-ruby/lib/interscript/interpreter.rb` — execution semantics
- `interscript-ruby/lib/interscript/stdlib.rb` — parallel replace, regex helpers
- `interscript-js/src/stdlib.js` — existing JS helper surface (start here, align to Ruby)

## Acceptance criteria
- All map fixtures from Ruby `spec/` produce identical output in TS runtime
- `npm publish` ships `dist/` with CJS + ESM + TypeScript declarations
- No `Opal.*` references remain in `interscript-js/`
- CI runs `npm run build && npm test` (TS compiled + tested)

## Estimated effort
3-5 days of focused work. Includes:
- TS scaffolding (4h)
- Stdlib port (8h)
- Interpreter port (16h)
- Parity fixtures (8h)
- Edge case resolution (8h)
- CI + packaging (4h)

## Related
- TODO 20 (dual ESM/CJS packaging) — depends on this
- TODO 04 (TS port) in main plan: same item
