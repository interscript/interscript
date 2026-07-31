# 88 — IR generation for ML maps

**Status:** P0
**Depends on:** #86, #87

## Problem

The Ruby JsonIR compiler needs to emit IR for the two ML-powered maps:
- `var-ara-Arab-Arab-rababa` (rababa function call)
- `var-tha-Thai-Zsym-ipa` (secryst function call, staging only)

Currently the JsonIR compiler may not emit funcall rules for rababa/secryst.
Need to verify + fix the IR shape if needed.

## Fix

1. Check that JsonIR emits `{kind: "funcall", name: "rababa", kwargs: {config: "200"}}`
2. Check that the TS runtime can parse this funcall
3. Generate IR for both ML maps
4. Add them to the parity suite (with Ruby-side validation)

## Acceptance

- [ ] `var-ara-Arab-Arab-rababa.json` generated with correct funcall shape
- [ ] interscript-ts loads and executes the funcall
- [ ] Parity suite includes both ML maps (with onnxruntime installed)
- [ ] Without onnxruntime: graceful error, not a crash
