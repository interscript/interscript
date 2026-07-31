# secryst-v2: 04 — ONNX export + interscript-ts integration

**Status:** SPECIFICATION
**Priority:** P0

## Same export pipeline as rababa (TODO.rababa/04)

The student model exports identically. The ONNX input/output names
match the Secryst translator interface already implemented in
interscript-ts (`src/ml/models/secryst/translator.ts`).

## interscript-ts integration

The SecrystModel already exists in `src/ml/models/secryst/`:
- `vocab.ts` — token vocabulary
- `masks.ts` — attention mask construction
- `translator.ts` — autoregressive decode loop
- `index.ts` — registered as "secryst" in the ML registry

To use the new distilled student:
1. Export the student ONNX with matching input names (src, tgt, masks)
2. Bundle the vocab (byte-level: 256 tokens, no YAML needed)
3. Publish to HuggingFace
4. Update the provisioner manifest

## Map integration

```ruby
# var-tha-Thai-Zsym-ipa.imp (existing map, no change needed)
stage {
  secryst model: "thai-ipa"
  # ... post-processing sub rules ...
}
```

The runtime loads the model via `loadModel({kind: "secryst", id: "thai-ipa"})`,
runs autoregressive decode, and passes the output to subsequent rules.

## Acceptance

- [ ] Student ONNX exported with correct input/output names
- [ ] Loads in interscript-ts via existing SecrystModel code
- [ ] All 11 test vectors pass
- [ ] Published to HuggingFace as `interscript/secryst-thai-ipa`
