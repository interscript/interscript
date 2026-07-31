# 62 — Rababa port (Arabic diacritization)

**Status:** IN PROGRESS
**Priority:** P0

## Goal

Port the Ruby Rababa diacritizer so `var-ara-Arab-Arab-rababa` works in
interscript-ts. Closes the gap from "all maps except rabba/secryst" to
"all maps, full stop".

## What to port (verified from source)

| Ruby source | TS port | Lines |
|---|---|---|
| `rababa/lib/rababa/arabic/encoders.rb` | `src/ml/models/rababa/encoder.ts` | ~100 |
| `rababa/lib/rababa/arabic/reconciler.rb` | `src/ml/models/rababa/reconciler.ts` | ~80 |
| `rababa/lib/rababa/arabic/diacritizer.rb` | `src/ml/models/rababa/diacritizer.ts` | ~100 |
| `rababa/lib/rababa/arabic/cleaner.rb` | `src/ml/models/rababa/cleaner.ts` | ~30 |
| `rababa/lib/rababa/arabic/haraqat.rb` (constants) | `src/ml/models/rababa/haraqat.ts` | ~20 |

## Model artifacts

- `diacritization_model_max_len_200.onnx` (60 MB)
- `config/arabic-max-len-200.json` (vocab + hyperparams)
- Source: `rababa/diacritization_model_max_len_200.onnx` in the rababa repo
- Hosting: bundle in `interscript-ts/models/` (or CDN; see #65)

## Test vectors

From `var-ara-Arab-Arab-rababa.imp`:
- `قطر` → `قِطْرَ`
- `abc` → `abc`
- `'Iz. Ibrāhīm as-Sa‘danī'` → `'Iz. Ibrāhīm as-Sa‘danī'`

These become interscript-ts tests.

## Acceptance

- [ ] All 3 test vectors pass with the official ONNX model
- [ ] Round-trip via `rababa_reverse` is identity on the diacritics only
- [ ] Performance: ≤ 200ms per name on Node, ≤ 500ms in browser via WASM SIMD
- [ ] Specs cover encoder, reconciler, full pipeline
