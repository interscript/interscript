# 13 — `interscript` gem 0.1.9 → 2.x in `interscript-api`

**Status:** DEFERRED — major integration rewrite

## Why
- `interscript-api` Gemfile pins `gem "interscript", "0.1.9"` (5 years stale)
- Latest published `interscript` is 2.4.5
- The v2 API is significantly different: `Interscript.detect` and `Interscript.transliterate` signatures changed; `Interscript.maps` returns differently; the `compiler:` keyword is gone

## What changes between 0.1.9 and 2.x
| API | 0.1.9 | 2.x |
|-----|-------|-----|
| `Interscript.transliterate(system, input)` | ✓ | ✓ (signature compatible) |
| `Interscript.detect(input, output, ...)` | Returns array of `[name, distance]` | Returns array of `[name, distance]` — same shape but `cache:` kwarg now `cache: <hash>` |
| `Interscript.maps` | Returns hash | Returns hash with system_code keys |
| `compiler:` kwarg | Accepts `Interscript::Compiler::Ruby` | Removed; interpreter is the only path |

## What to change in `interscript-api`
1. Bump Gemfile: `gem "interscript", "~> 2.4"`
2. Update `lib/interscript-api/graphql/types/query.rb`:
   - Remove `compiler: Interscript::Compiler::Ruby` from `Interscript.transliterate` call
   - Remove same from `Interscript.detect` call
   - Remove `require "interscript/compiler/ruby"` at top
3. Update test.yml env: `INTERSCRIPT_GEM_VERSION: "2.4.5"` (or remove and let bundle resolve)
4. Verify existing specs still pass — may need fixture updates

## Expected effort
S in code changes. M in validation (Lambda behavior may shift).

## Blockers
None — pure dependency bump.
