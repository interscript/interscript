# 46 — Vue explorer wired to interscript-ts

**Status:** BLOCKED on TODO 43 (interscript-ts publish)

## Why
`interscript.org-v2/src/components/MapExplorer.vue` is currently a UI stub. Needs to:
1. Pull map list from a JSON index (or query interscript-ts)
2. Transliterate user input via interscript-ts
3. Show input/output side-by-side
4. Display map metadata (authority, language, scripts)

## Implementation plan
```vue
<script setup lang="ts">
import { ref, onMounted, computed } from "vue"
import { transliterate, loadMap, configure, filesystemStrategy } from "interscript-ts"

const systemCode = ref("bgnpcgn-ukr-Cyrl-Latn-2019")
const input = ref("Антон")
const output = computed(() => {
  try { return transliterate(systemCode.value, input.value) }
  catch { return "(error)" }
})
</script>
```

For browser use, maps must be loadable. Options:
- Bundle a curated subset via `bundledStrategy`
- Fetch on demand via `httpStrategy` (TODO 47)
- Embed IR for all maps at build time (TODO 45)

## Files
- `interscript.org-v2/src/components/MapExplorer.vue`
- `interscript.org-v2/package.json` — add `interscript-ts` dependency
- `interscript.org-v2/astro.config.mjs` — alias for SSR

## Acceptance
- User picks system code from dropdown
- Types input, sees transliteration in real-time
- No browser errors; SSR renders initial state correctly

## Effort
S (1-2 hours) once interscript-ts is published
