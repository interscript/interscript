# 33 — DSL parser for `.imp` files (full Ruby parity)

**Status:** TODO — large effort

## Why
Today the TS runtime consumes pre-compiled `CompiledMap` JSON IR. Map authors write `.imp` files in a Ruby DSL. To fully replace the Ruby gem, TS needs to parse `.imp` files directly.

Two approaches:

### Option A: PEG parser (recommended)
- Use `@pegjs/parser` or similar
- Grammar in `src/dsl/grammar.pegjs`
- Build AST from parse tree, then compile to `CompiledMap`

### Option B: Reuse Ruby
- Keep `.imp` parsing in Ruby
- TS only consumes pre-compiled IR
- Simpler but maintains Ruby dependency for map authoring

## Recommendation
**Option B** for the foreseeable future. Map authoring is rare; runtime use is frequent. The Ruby DSL is mature and well-tested. TS consuming pre-compiled IR is the right division of labor.

If option A ever needed: 2-3 weeks of work for a faithful port.

## Scope (if Option A)
- PEG grammar for stage/rule/item syntax
- AST builder mapping to `types.ts` discriminated unions
- Tests against every `.imp` file in `interscript/maps/maps/` (~300 files)
- Performance: parse + compile < 100ms per map

## Effort
L (2-3 weeks) if needed. Not currently planned.
