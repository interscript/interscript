# 28 — Archive Opal-related repos

**Status:** DONE

## Action taken
Archived 5 repos via `gh repo archive`:
- interscript/Onigmo
- interscript/opal
- interscript/opal-onigmo
- interscript/opal-webassembly
- interscript/rambling-trie

Closed related PRs without merge:
- interscript/opal#1 (upstream sync)
- interscript/Onigmo#2 (upstream sync)

## Why
User directive: "we won't touch them anymore". The Interscript runtime path no longer depends on Opal — the new `interscript-ts` package provides a native TS runtime. The legacy Opal-based JS bundle in `interscript-js` is being replaced.

## Impact
- Existing clones still work (read-only)
- Issues/PRs frozen
- GitHub marks repos as `archived: true`
- Future work uses `interscript-ts` instead

## Related
TODO 32 — Interscript-js deprecation plan (legacy package replaced by interscript-ts)
