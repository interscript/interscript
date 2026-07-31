# Modernization Research: ML Model Paths for Interscript (2026 SOTA)

**Status:** Research note
**Date:** 2026-07-31

## Context

The current ML models in Interscript were trained ~2021 using then-SOTA
architectures (Tacotron CBHG for Rababa, vanilla transformer for Secryst).
The field has advanced significantly. This document maps the modernization
options.

## Rababa (Arabic Diacritization)

### Current state
- Architecture: Tacotron CBHG seq2seq (2017-era)
- Size: 60 MB ONNX (unquantized)
- Training data: Tashkeela corpus (~3M words)
- Performance: ~200ms/inference (Node), ~500ms (browser WASM)

### Option A: ByT5-Small Fine-tune (RECOMMENDED)

**Why:** Character-level T5 was designed for exactly this class of problem.
Pretrained on multilingual text; fine-tune on diacritization data.

**Size:** 300 MB unquantized → ~30 MB int8 quantized
**Accuracy:** DER ~3% (current Tacotron: ~5-7%)
**Inference:** ~50ms/word (quantized, SIMD)

**Training plan:**
1. Download Tashkeela++ or OpenDiacritizer dataset (~50M words)
2. Fine-tune `google/byt5-small` via HuggingFace Transformers
3. Export to ONNX with `optimum-exporters`
4. Quantize to int8 via `onnxruntime` quantization tools
5. Benchmark DER vs baseline

**Tools:** HuggingFace Transformers, optimum, ONNX Runtime

### Option B: Microkimi-style Mini Transformer (AMBITIOUS)

**Why:** Very small transformers (1-10M params) can be distilled from
larger models. The diacritization task is narrow enough that 5M params
suffice.

**Size:** ~5-10 MB quantized
**Accuracy:** Likely comparable to ByT5-small (DER ~4-5%)
**Inference:** <20ms/word in browser

**Training plan:**
1. Train baseline (ByT5-small fine-tuned — Option A)
2. Distill into a 5M-param transformer via knowledge distillation
3. Quantize to int4
4. Benchmark

**Tools:** PyTorch, optimum, custom distillation loop

### Option C: Quantize Current Model (INTERIM — SHIP TODAY)

**Why:** No retraining needed. Take the existing 60MB ONNX → int8
quantize → ~15MB.

**Size:** ~15 MB
**Accuracy:** Same as current (quantization-aware inference)
**Inference:** Same latency, 4× smaller download

**Steps:**
1. `python -m onnxruntime.quantization.quantize --input model.onnx --output model-int8.onnx --quant_format QDQ`
2. Verify outputs match (byte-for-byte on test vectors)
3. Publish as `rababa/200/int8`

## Secryst (Learned Transliteration)

### Current state
- Architecture: Vanilla seq2seq transformer
- Active model: Thai → IPA (trained on Wiktionary)
- No quantization

### Option A: ByT5 Fine-tune

Same pattern as Rababa Option A. ByT5 is character-level → no tokenization
issues. Pretrained on multilingual text including Thai.

### Option B: Shared Multilingual Backbone

If multiple secryst maps emerge (Thai, Khmer, Amharic):
1. Train a shared multilingual transliteration backbone
2. Fine-tune per task via LoRA
3. Each task adds <1MB of LoRA weights on top of the shared model

This is the NLLB pattern, applied to transliteration.

### Option C: Mamba / State Space Model

For very long sequences (paragraphs of Thai), linear-time Mamba beats
transformer's quadratic attention. Worth benchmarking but probably
overkill for single-name transliteration.

## Cross-cutting: Browser Deployment

### Quantization
- int8: standard for 2026. 4× size reduction, ~2% accuracy loss.
- int4: bleeding edge. 8× reduction, ~5% accuracy loss.
- Recommended: int8 for production.

### WebGPU
- onnxruntime-web supports WebGPU execution provider
- 5-10× faster than WASM SIMD on supported GPUs
- Currently ~60% browser support (Chrome, Edge, Safari 17+)
- Progressive enhancement: try WebGPU, fall back to WASM

### Model Caching
- Service Worker caches ONNX files after first download
- IndexedDB for models > 5MB (localStorage has 5MB limit)
- Manifest with SHA256 verification for integrity

## Recommended Path

1. **Immediate (this PR):** Ship current Rababa ONNX via the new ML
   abstraction layer. Works, just heavy.
2. **Short term (2 weeks):** Quantize to int8 (Option C). 15MB model,
   same accuracy.
3. **Medium term (1 month):** Train ByT5-small (Option A). 30MB, better
   accuracy.
4. **Research arc:** Evaluate mini-transformer distillation (Option B)
   and shared backbone for secryst.

## References

- ByT5: Xue et al., 2022. "ByT5: Towards a Token-Free Future with
  Pre-trained Byte-to-Byte Models"
- Tashkeela: Azhari et al., 2016. "Tashkeela: Novel corpus of Arabic
  vocalized texts for automatic diacritization"
- OpenDiacritizer: AlKhamissi et al., 2021
- microkimi: https://github.com/serphen/microkimi (tiny transformer training)
- onnxruntime quantization:
  https://onnxruntime.ai/docs/performance/model-optimizations/quantization.html
