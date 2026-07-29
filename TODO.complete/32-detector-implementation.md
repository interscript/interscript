# 32 — Detector implementation (`interscript-ts`)

**Status:** TODO

## Why
`interscript-ts` public API exports `detect()` but the current implementation throws "not yet implemented". The Ruby gem has `Interscript::Detector` (~150 LOC) that scans all maps and ranks candidates by Levenshtein distance.

## Scope

### TS implementation
Create `src/detector.ts`:

```typescript
import type { DetectionResult, LoadStrategy } from "./types.js"
import { executeStage } from "./runtime/interpreter.js"

export function detect(
  input: string,
  output: string,
  maps: Iterable<[string, CompiledMap]>,
  opts: DetectOptions = {},
): DetectionResult[] {
  const pattern = opts.mapPattern ? globToRegExp(opts.mapPattern) : /.*/
  const candidates: DetectionResult[] = []

  for (const [name, map] of maps) {
    if (!pattern.test(name)) continue
    try {
      const transliterated = executeStage(map, "main", input)
      const distance = levenshtein(transliterated, output)
      candidates.push({ mapName: name, distance })
    } catch {
      continue
    }
  }

  return candidates.sort((a, b) => a.distance - b.distance)
}
```

### Levenshtein
Either implement (10 LOC) or depend on `fastest-levenshtein` (npm).

### Map enumeration
`MapLoader` currently exposes `load()` only. Add `enumerate()` to iterate known maps:
- For filesystem strategy: `readdirSync(dir).filter(f => f.endsWith('.json'))`
- For bundled strategy: `Object.keys(bundle)`

## Acceptance criteria
- Detect matches Ruby behaviour for the same (input, output, map set)
- Performance: < 1s for full map set (~200 maps) on commodity hardware
- Optional `mapPattern` filter short-circuits scan

## Effort
S-M (4-8 hours)
