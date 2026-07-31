# 89 — End-to-end ML parity test

**Status:** P0
**Depends on:** #85, #86, #87, #88

## Goal

A single test suite that runs the full pipeline:

```
Ruby test vector → JsonIR → interscript-ts (with onnxruntime) → output → compare
```

For both ML maps:
- `var-ara-Arab-Arab-rababa`: `قطر` → `قِطْرَ`
- `var-tha-Thai-Zsym-ipa`: `คฺวาม-วาว` → `kʰwaːm˧.waːw˧`

## Approach

1. Install `onnxruntime-node` in the test environment
2. Download the model file locally (60MB)
3. Run `transliterateAsync` against each test vector
4. Compare with expected output

## CI strategy

- ML tests run in a separate CI job (needs the model file)
- Regular parity tests (rule-based) don't need onnxruntime
- ML job is optional — doesn't block PRs that don't touch ML code

## Acceptance

- [ ] `test/ml/e2e-parity.test.ts` exists
- [ ] All test vectors for `var-ara-Arab-Arab-rababa` pass
- [ ] Tests skip gracefully when onnxruntime isn't installed
- [ ] CI workflow runs ML tests separately
