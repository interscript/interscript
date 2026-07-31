# 64 — Modernize Rababa model (2026 SOTA)

**Status:** RESEARCH
**Priority:** P2

## Why

The current Rababa ONNX model:
- Is from 2021 (Tacotron-era architecture)
- Weighs 60 MB (no quantization)
- Uses a CBHG encoder — superseded for character-level tasks
- Trained on Tashkeela (limited; pre-2020 corpus)

2026 options are dramatically better on all axes.

## Candidate architectures

### A. ByT5-small (character-level T5)

- 300 MB unquantized → ~30 MB int8
- Character-aware, no tokenization required
- Pretrained on multilingual text; fine-tune on Tashkeela++
- SOTA on Arabic diacritization benchmarks (DER ~3%)

**Cost:** moderate training run; new model file.
**Benefit:** ~2× lower error rate, 50% smaller, simpler pipeline (no
separate encoder/reconciler — model is end-to-end).

### B. Distilled mini-transformer (microkimi-style)

- ~5M parameter transformer (à la microkimi)
- Trained from scratch on Tashkeela++ + synthetic data
- Quantized to int4: ~3-5 MB
- Inference: <20ms per name in browser

**Cost:** training run + distillation.
**Benefit:** tiny enough to bundle in the website by default.

### C. Quantized current model (interim)

- Take the existing 60MB ONNX
- int8 quantize via `onnxruntime` tools → ~15 MB
- Prune the CBHG encoder's redundant filters
- No retraining required

**Cost:** a few hours of work.
**Benefit:** 4× size reduction with no accuracy loss; ships today.

## Recommended path

1. **Immediate (port):** ship #62 with current 60 MB model. Works, just heavy.
2. **Next month:** apply (C) — quantize to ~15 MB. Ship.
3. **Research arc:** train (A) or (B) on Tashkeela++ + synthetic augmentation. Compare DER vs current. If better, replace.

## Evaluation harness

Need a benchmark script that runs each model variant against:
- Tashkeela++ test split
- The 3 vectors in `var-ara-Arab-Arab-rababa.imp`
- A held-out set of real-world news text

Report: DER (diacritization error rate), WER (word), size, latency.

## Acceptance

- [ ] Benchmark script committed under `scripts/ml-bench/`
- [ ] Quantized variant of current model produced (int8 ONNX, ~15 MB)
- [ ] Comparison report: baseline vs quantized vs ByT5 (if trained)
- [ ] Decision documented on which to ship as default
