# 48 — TypeScript DSL parser for `.imp` files

**Status:** DEFERRED — large effort, currently optional

## Why
Today, `.imp` map files are authored in a Ruby DSL and parsed only by the Ruby gem. Authoring maps without Ruby requires a TS-native parser.

## Trade-off
- **Cost:** ~2000-3000 LOC, careful grammar work, edge cases
- **Benefit:** Map authors can use any toolchain; no Ruby dependency for authoring
- **Alternative:** Keep Ruby as the authoring tool forever (it works fine)

## Recommendation
Defer indefinitely unless there's a strong author-experience motivation. The Ruby DSL is mature; the TS runtime can consume IR without needing to parse `.imp` files.

## If pursued
- Use `tree-sitter` or `chevrotain` for the parser
- Mirror Ruby DSL syntax exactly for compatibility
- Add round-trip tests: parse `.imp` → AST → regenerate IR → verify matches Ruby output

## Effort
L (multi-week)
