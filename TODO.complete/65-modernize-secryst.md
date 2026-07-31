# 65 — Modernize Secryst models (2026 SOTA)

**Status:** RESEARCH
**Priority:** P2

## Why

Secryst's vanilla transformer is fine architecturally but:
- Trained once on limited parallel data (Wiktionary Thai-IPA)
- No use of pretrained multilingual embeddings
- No quantization
- Single model per task; no shared backbone

## Candidates for Thai → IPA (the active secryst map)

### A. ByT5 fine-tune

- Pretrained on multilingual text including Thai
- Fine-tune on Wiktionary Thai-IPA pairs
- Character-level → no tokenization issues
- Should beat the current vanilla transformer

### B. NLLB-inspired encoder

- Multilingual pretrained encoder + Thai-specific decoder
- Larger upfront cost but reusable across all secryst-using maps

### C. Mamba / State Space Model

- Linear-time sequence modeling
- Better latency on long sequences than transformer
- Worth testing for Thai (long-range tone interactions)

### D. Quantize existing model

- Same int8 path as Rababa (#64)
- Smaller model, same accuracy

## Cross-task backbone

If multiple secryst maps emerge (Khmer diacritics, Amharic morphology,
etc.), consider training a shared multilingual transliteration backbone
and fine-tuning per task. This is the NLLB pattern.

## Training data

- **Thai-IPA:** Wiktionary pairs (already in use)
- **Khmer:** Khmer diacritics repo has parallel data
- **Synthetic:** use the existing rule-based maps to generate
  "noisy" parallel data, then have the ML model learn the residual
  corrections

## Acceptance

- [ ] ONNX export of current Thai-IPA model produced
- [ ] Benchmark against test vectors
- [ ] Document training data preparation scripts
- [ ] If ByT5 path pursued: fine-tune script + comparison report
