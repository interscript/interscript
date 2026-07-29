# 38 — Deprecate `interscript-js` in favor of `interscript-ts`

**Status:** TODO (gated by interscript-ts v1.0)

## Why
`interscript-js` (npm: `interscript`) is the current package. It uses prepared JS maps (compiled from Ruby), CommonJS only, and contains a legacy Opal bundle locally. Once `interscript-ts` reaches v1.0 with feature parity, deprecate `interscript-js`.

## Plan

### Phase 1: interscript-ts v0.x → v1.0 (next 1-3 months)
- Land TODO 31 (JSON IR compiler)
- Land TODO 32 (detector)
- Land TODO 35 (npm publish with provenance)
- Real parity tests pass against Ruby suite

### Phase 2: deprecation announcement
- Add deprecation notice to interscript-js README
- npm deprecate: `npm deprecate interscript@2.4.5 "Use interscript-ts instead — see migration guide"`
- Blog post / GitHub announcement

### Phase 3: name takeover (optional)
- Once interscript-ts is stable, publish it as `interscript` v3.0.0
- interscript-js becomes deprecated v2.x
- Migration guide published

### Phase 4: archive (1+ year post-deprecation)
- Archive `interscript/interscript-js` repo
- Last published version remains on npm forever

## Migration guide for users
```js
// Before (interscript-js)
const Interscript = require("interscript")
Interscript.load_map("bgnpcgn-ukr-Cyrl-Latn-2019").then(() => {
  console.log(Interscript.transliterate("...", "..."))
})

// After (interscript-ts)
import { transliterate, configure } from "interscript-ts"
configure({ strategies: [/* ... */] })
console.log(transliterate("bgnpcgn-ukr-Cyrl-Latn-2019", "..."))
```

## Acceptance criteria
- interscript-ts npm package published and provenance-enabled
- Migration guide on https://www.interscript.org/docs/migrating-from-js
- Deprecation notice on legacy npm package
- 6-month sunset period before archiving legacy repo
