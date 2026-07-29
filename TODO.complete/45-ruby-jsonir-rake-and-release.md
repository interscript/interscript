# 45 — Ruby JsonIR Rake task + release

**Status:** DEFERRED — gated on Ruby JsonIR PR merge

## Why
The Ruby JsonIR compiler is on branch `feat/json-ir-compiler` (PR interscript/interscript-ruby#757). Once merged:
- Add a Rake task to emit IR for all maps as part of release
- Publish IR bundle as `interscript-maps-ir` npm package (or as a release artifact)
- interscript-ts can depend on the published IR instead of generating its own

## Action items (post-merge)
1. Add `rake compile:json_ir` task (skeleton already in the PR)
2. Set up CI workflow that emits IR on tag push
3. Either:
   - Publish IR bundle to npm as `interscript-maps-ir`
   - Or attach as GitHub release asset on `interscript-maps`
4. Update `interscript-ts` README to consume published IR

## Consumer benefit
- No Ruby dependency at runtime
- npm package ~2-5 MB (compressed JSON IR for ~300 maps)
- Browser-friendly (JSON imports tree-shakeable)

## Effort
S (after Ruby PR merges)
