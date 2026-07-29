# 12 — GraphQL 1.13 → 2.x (`interscript-api`)

**Status:** DEFERRED — major API rewrite

## Why
- GraphQL-Ruby 2.x dropped legacy APIs, has performance improvements, modern type system
- Current `graphql ~> 1.13` is in maintenance mode
- Ruby 4.0 readiness is independent of this — 1.13 works on 3.4

## What changes in 2.x
- Removed deprecated `.define` style (we already use class-based — fine)
- `GraphQL::Schema::Object` API stable
- `Schema.execute` signature stable
- New: `LinearScale`, persisted queries, lookhead — not relevant to this codebase

## Expected effort
S in practice. Most code should work as-is. The `field :name, Type do ... end` DSL is unchanged.

## Blockers
None technical. Just needs:
1. Bump `gem "graphql", "~> 2.1"` in Gemfile
2. Run specs (1 existing spec in `lambda_function_spec.rb`)
3. Verify `InterscriptApi::GraphQL::Schema.execute(query)` still returns `{data: ...}` JSON

## Validation
End-to-end test in staging Lambda before promoting to prod.
