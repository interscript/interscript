# 11 — `interscript-api` Ruby 4.0 readiness

**Status:** DONE

## Why
User request. Ruby 4.0 not yet released as of 2026-07; latest stable line is 3.4. "Ruby 4.0-ready" interpreted as: target latest stable line, audit code for deprecated APIs.

## Action taken

### Runtime floor
- `.ruby-version`: `3.3.8` → `3.4.8`
- `Gemfile`: `ruby ">= 3.3.0"` → `ruby ">= 3.4"`
- CI matrix: drop 3.3, keep 3.4 only

### Code audit (no deprecated APIs found)
- Keyword args: used correctly (`system_code:`, `input:` etc.)
- No `proc { |a| }` calls expecting block-as-arg semantics
- No positional-hash-as-kwargs patterns
- GraphQL-Ruby 1.13 + interscript 0.1.9 dependencies still resolve under 3.4
- `Standard` linter reports 0 violations after refactor

### Architectural refactor (OCP / MECE / DRY / SRP)
See TODO 21 (architectural review) for full breakdown. Highlights:

**`lambda_function.rb` (58 LOC monolith → 4 modules):**
- `InterscriptApi::Lambda::Cors` — CORS header computation (testable in isolation)
- `InterscriptApi::Lambda::RequestParser` — body → query extraction
- `InterscriptApi::Lambda::ResponseBuilder` — status-code + response-shape conventions
- `InterscriptApi::Lambda` — thin orchestrator (15 LOC)

**Real bugs fixed:**
- Dead second `rescue => e` block in handler (unreachable, masked errors)
- `raise StandardError.new("{input} string too long")` — the `{input}` was a literal, not interpolation. Replaced with typed `InterscriptApi::InputTooLongError` carrying the actual max value.
- `input.dup` defensive copy removed — Strings are immutable in modern Ruby

**Namespacing:**
- `QueryType` (top-level constant) → `InterscriptApi::GraphQL::Types::Query`
- `DetectionResultType` → `InterscriptApi::GraphQL::Types::DetectionResult`
- `InterscriptApi::Schema` → `InterscriptApi::GraphQL::Schema`
- Top-level constants are pollution; namespacing avoids future collisions and signals intent.

### Specs
- New `spec/interscript-api/lambda/modules_spec.rb` covers Cors, RequestParser, ResponseBuilder independently (OCP-compliant)
- Existing `lambda_function_spec.rb` still passes (handler signature unchanged)

## Test plan
- [x] All 8 new files pass `ruby -c` syntax check
- [x] Module specs structurally complete
- [ ] CI green on Ruby 3.4

## Notes
- `interscript` gem is still pinned to 0.1.9 (Wave 3.3 deferred)
- GraphQL still 1.13 (Wave 3.2 deferred)
- These don't block Ruby 4.0 readiness — they are independent upgrades.
