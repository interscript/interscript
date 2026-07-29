# 21 — Architectural review (OCP / MECE / DRY / performance)

**Status:** DONE for code-bearing modules touched in this round

## Why
User directive: ensure code cleanliness, OOP, MECE, model-driven, semantically-driven, OCP, DRY, performance. Good specs throughout.

## Approach
Per-touched-module review. Findings + fixes below.

---

## `interscript-api/lib/interscript-api/lambda_function.rb` (58 LOC → split into 4 modules)

### Issues found (real bugs, not style)
1. **Dead code**: Two consecutive `rescue => e` blocks (lines 37-44) — second was unreachable, masked errors
2. **Bug**: `raise StandardError.new("{input} string too long")` — `{input}` is a literal string, not interpolation. Caller gets confusing error message.
3. **Mutation smell**: `input.dup` defensive copy — Strings are immutable since Ruby 3.0
4. **SRP violation**: One method doing CORS, body parsing, GraphQL dispatch, response shaping
5. **Untyped error**: bare `StandardError` is opaque

### Fixes applied (OCP / MECE)
- Split into:
  - `Lambda::Cors` — pure function: `event → headers`. Easy to test, easy to extend with new headers
  - `Lambda::RequestParser` — pure function: `body → query`. Easy to test
  - `Lambda::ResponseBuilder` — value-object + factories. New shapes (`not_found`, `redirect`, etc.) added without modifying callers (OCP)
  - `Lambda` (orchestrator) — 15 LOC, just composes the modules
- `InterscriptApi::Error` + `InterscriptApi::InputTooLongError` — typed error hierarchy, callers can rescue precisely
- Lambda handler signature unchanged — backward compat with AWS config

### Tests added
- `spec/interscript-api/lambda/modules_spec.rb` covers all three helper modules in isolation (OCP-compliant: each can be replaced/extended without touching others' specs)

---

## `interscript-api/lib/interscript-api/graphql/types/query.rb`

### Issues found
1. **Top-level constants**: `QueryType`, `DetectionResultType` were at top level → namespace pollution
2. **Hidden state**: `@cache ||= {}` referenced instance var on resolver — works but unclear whose cache
3. **Bug**: `raise StandardError.new("{input} string too long")` (see above)
4. **Unused defensive copy**: `input.dup` (see above)

### Fixes applied (MECE / model-driven)
- `InterscriptApi::GraphQL::Types::Query`, `DetectionResult` — proper namespace
- `query_cache` private method — intent-revealing name, lazy init
- Typed errors
- Field declarations at top of class, resolvers below — clear visual separation of "what's exposed" from "how it works" (semantically-driven)

---

## `interscript-js/src/stdlib.js`

### Issues found (real bugs caught by ESLint)
1. `map_list(map)` had unused `map` param — callers may have been passing map name expecting filtering
2. Multiple `==`/`!=` instead of `===`/`!==` — coercion footguns
3. Unused `opts` params in `downcase`/`compose`/`decompose` — unclear API contract

### Fixes applied (DRY / correctness)
- All `==` → `===`
- Removed unused params; prefixed genuine unused-args with `_`
- ESLint + Prettier in CI will catch future drift

---

## `interscript-ruby/lib/**/*`

### Issues found by StandardRB
- 953 violations across 46 files (mostly style)
- 23 remaining after auto-fix (mostly semantic — Style/AndOr in conditions, Lint/AssignmentInCondition, etc.)

### Fixes applied
- 930 auto-fixed (formatting, string quotes, etc.)
- `.standard.yml` enforces lib/ only — spec/ and bin/ left for incremental cleanup
- CI runs StandardRB job — future PRs are blocked if violations introduced

---

## `rababa/python/**/*`

### Issues found by ruff
- 281 violations (mostly imports + types)
- 36 remaining after auto-fix (real bugs: F821 undefined-name false positives, F811 dup defs in trainer.py)

### Fixes applied (DRY / correctness)
- 245 auto-fixed (PEP 585, deprecated imports, unused vars, isort)
- 80 unsafe-fixed (mostly annotation modernization)
- All 56 files formatted
- 36 remaining documented in TODO 08

---

## Cross-cutting improvements
- All touched modules now have **single responsibility**
- Public APIs are **kwargs-first** (Ruby 3.x style)
- Error hierarchy is **typed**, not bare `StandardError`
- Specs cover **isolated units** (OCP-compliant — each module's spec doesn't depend on others)

## Outstanding tech debt
- 23 StandardRB violations in `interscript-ruby/lib/interscript/utils/regexp_converter.rb` and `lib/interscript/visualize/{json,nodes}.rb` — semantic, need human review
- 36 ruff violations in `rababa/python/{arabic,hebrew}` — research code with real bugs (duplicate function defs, undefined names) — separate effort

These are tracked in TODOs 06 and 08 respectively.
