# 93 — Model hosting on HuggingFace Hub

**Status:** P1
**Depends on:** #89

## Why

Models need a CDN for browser/HTTP loading. HuggingFace is:
- Free for open-source
- Global CDN
- Standard in the ML community
- Already used by @xenova/transformers ecosystem
- Direct download URLs (no auth needed for public models)

## Setup

1. Create `huggingface.co/interscript` org
2. Create repos:
   - `interscript/rababa-arabic-max-len-200`
   - `interscript/secryst-thai-ipa`
3. Upload ONNX model + config + vocab via `huggingface-cli upload`
4. Add README with model card (architecture, training data, license)
5. Set `setModelBase("https://huggingface.co/interscript/interscript-models/resolve/main")`

## Model card template

```markdown
---
license: mit
language: ar
tags: [arabic, diacritization, onnx]
---

# Rababa Arabic Diacritization (max_len=200)

## Architecture
Tacotron CBHG seq2seq, trained on Tashkeela corpus.

## Inputs
- `src`: int64[batch, seq] — token IDs
- `lengths`: int64[batch] — sequence lengths

## Outputs
- Predictions: float32[batch, seq, 15] — haraqat class logits

## Performance
- DER: ~5% on Tashkeela test split
- Size: 60 MB (unquantized)
- Latency: ~200ms/word (Node), ~500ms (WASM SIMD)
```

## Acceptance

- [ ] HuggingFace org created
- [ ] Rababa model uploaded with model card
- [ ] Direct download URL works from interscript-ts
- [ ] setModelBase() points at HF in production
