# 37 — Wire `interscript-ts` into the Vue map explorer

**Status:** TODO (blocked by TODO 31 — JSON IR compiler)

## Why
`MapExplorer.vue` currently stubs the output: `[interscript-ts would transliterate "..."]`. Once `interscript-ts` can load maps via JSON IR, replace the stub with real transliteration.

## Scope

### Install
```bash
npm install interscript-ts interscript-maps
```

### Update MapExplorer.vue
```vue
<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { transliterate, configure } from "interscript-ts"
import { bundledStrategy } from "interscript-ts/loaders/bundled"

onMounted(async () => {
  const maps = await import("interscript-maps")
  configure({ strategies: [bundledStrategy(maps)] })
})

const output = computed(() => {
  try {
    return transliterate(selected.value, input.value)
  } catch (e) {
    return `Error: ${(e as Error).message}`
  }
})
</script>
```

### Map data
Either:
- (a) Bundle all maps into the page (~MB of JSON — bad)
- (b) Lazy-load map on demand via fetch from CDN

Option (b) is required for performance. Add `fetchJsonIRStrategy(systemCode)` that fetches `https://cdn.interscript.org/maps/${systemCode}.json`.

## Acceptance criteria
- Real-time transliteration as user types
- < 100ms latency per keystroke on commodity hardware
- Graceful error handling for unknown systems

## Effort
M (1-2 days once TODO 31 lands)
