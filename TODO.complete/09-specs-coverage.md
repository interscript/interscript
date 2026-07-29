# 09 — Specs coverage gaps

**Status:** ONGOING — partial progress, full coverage requires per-repo effort

## What was added in this round
- `interscript-api/spec/interscript-api/lambda/modules_spec.rb` (new) — 11 specs covering `Lambda::Cors`, `Lambda::RequestParser`, `Lambda::ResponseBuilder`
- `interscript-ruby`: 7 existing specs untouched; lint fixes don't change behavior
- `rababa`: 4 existing specs untouched
- `interscript-js`: existing test.js lint-fixed; no new tests

## Remaining gaps
| Repo | Gap | Effort |
|------|-----|--------|
| `interscript-ruby/lib/interscript/utils/regexp_converter.rb` | No direct specs (covered indirectly via map specs) | M |
| `interscript-ruby/lib/interscript/visualize/{json,nodes}.rb` | No specs | S |
| `rababa/lib/rababa/{arabic,hebrew}/*` | No specs for individual cleaner/diacritizer components | M |
| `interscript-js/src/stdlib.js` | Only 3 tests; no tests for `_load_path` branches (browser/Node/JSON/jseval) | M |

## Recommendations
- Use **real model instances** (no `double()`), per project rule
- Test public behavior, not internals
- For each new module, write specs first (TDD) — see `lambda/modules_spec.rb` as the pattern

## Tooling note
- StandardRB includes `Style/Documentation` (off by default) — could enable for stricter API-doc enforcement
- Code coverage: add `simplecov` to all Ruby repos; gate CI on coverage % once baseline established
