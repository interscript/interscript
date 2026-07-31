# 71 — Performance benchmarks + regression budgets

**Status:** TODO
**Priority:** P1

## Problem

We have `bench.bench.ts` but no published numbers and no regression
budget. A 2× slowdown could ship without anyone noticing.

## Fix

### Benchmark suite (already exists, needs expansion)

Cover:
- Map loading (filesystem, http, bundled) — strategies compared
- Single transliteration by script family (Cyrillic, Arabic, Han, etc.)
- Parallel mode (trie) vs megaregexp mode — explicit comparison
- Batch transliteration (10, 100, 1000 items)
- Worker overhead vs main thread
- ML inference (Rababa + Secryst) — cold start vs warm

### Regression budgets

Define per-benchmark budgets in `bench-budgets.json`:
```json
{
  "transliterate.bgnpcgn-ukr-Cyrl-Latn-2019.Антон": { "maxUs": 1500 },
  "batch.bgnpcgn-ukr-Cyrl-Latn-2019.100items": { "maxMs": 80 }
}
```

CI fails if any benchmark exceeds budget. Budget can be raised via PR
with documented justification.

### Public dashboard

Stream results to `/status` page (already exists) so users see live
performance alongside parity %.

## Acceptance

- [ ] Benchmark suite expanded
- [ ] `bench-budgets.json` committed with current numbers as baseline
- [ ] CI workflow runs benchmarks on every PR; fails on regression
- [ ] `/status` shows latest benchmark snapshot
