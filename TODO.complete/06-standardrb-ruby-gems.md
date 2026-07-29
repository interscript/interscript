# 06 — StandardRB in CI for all Ruby gems

**Status:** DONE for code-bearing repos; N/A for data-only `maps`

## Why
Only `rababa` enforced StandardRB. Without enforcement, code style drifts. StandardRB is the Ruby community's low-config lint.

## Action taken
Per repo:
1. Add `gem "standard", group: :development, require: false` to Gemfile
2. Add `.standard.yml` (ignore vendor/, tmp/, pkg/)
3. Run `standardrb --fix` once to auto-correct
4. Add `standard` job to CI workflow

## Coverage

| Repo | Files touched | Remaining violations | PR |
|------|---------------|----------------------|-----|
| `interscript-ruby` | 46 lib/ files; 953 → 23 violations | 23 (manual review) | interscript/interscript-ruby#755 |
| `interscript-api` | 6 files; 41 → 0 violations | 0 | interscript/interscript-api#26 |
| `rababa` | (already enforced) | 0 | — |
| `maps` | N/A (no Ruby code; data gem only) | — | — |

## Remaining violations (interscript-ruby)
23 in `lib/interscript/utils/regexp_converter.rb` and `lib/interscript/visualize/{json,nodes}.rb`. Need manual review (Style/AndOr, Lint/AssignmentInCondition, Style/IdenticalConditionalBranches — semantic, not just formatting). Tracked in TODO `23-ruby-deprecation-audit.md` and the architectural review.

## Notes
- CI job runs `bundle exec standardrb` with no `--fix` — fails on any violation.
- Future violations are blocked at PR time.
