# Modernization Research: ML Model Paths for Interscript (2026 SOTA)

**Status:** Research note — REVISED
**Date:** 2026-07-31
**Key insight:** Quantization is NOT the path. Train a better model.

## Why quantization is wrong

Quantizing the current Tacotron CBHG makes it smaller but doesn't fix
its fundamental problem: it's a 2021-era architecture designed for
text-to-speech, repurposed for diacritization. Even at full precision,
its DER (diacritization error rate) is ~5-7%. A modern architecture
trained from pretraining achieves ~2-3% — better accuracy, not just
smaller size.

The correct path: **train a new model with a better architecture**.

## Rababa (Arabic Diacritization) — Recommended Path

### ByT5-small fine-tune (PRIMARY)

**Why ByT5:**
- Character-level: no tokenization, no vocab mismatch. Every byte
  is a token. Arabic chars, haraqat, punctuation — all handled
  natively.
- Pretrained on multilingual text: the model already "knows" Arabic
  letter shapes and bigram frequencies before fine-tuning.
- Fine-tuning for diacritization takes hours, not days.
- SOTA on Arabic DER benchmarks (every recent paper uses T5/ByT5).

**Architecture:**
```
Input:  "قطر" (raw bytes)
  → ByT5 encoder (12 layers, 2096 hidden)
  → ByT5 decoder (4 layers, 2096 hidden)
Output: "قِطْرَ" (raw bytes with haraqat inserted)
```

**Training:**
1. `pip install transformers datasets accelerate`
2. Load `google/byt5-small` from HuggingFace
3. Fine-tune on Tashkeela++ (cleaned + deduplicated, ~50M words)
4. Also add synthetic augmentation from OpenDiacritizer
5. Evaluate on held-out test set
6. Export to ONNX: `optimum-cli export onnx --model ./byt5-rababa ./rababa-byt5-onnx`

**Expected:**
- DER: ~2-3% (vs current 5-7%)
- Size: ~120 MB (ByT5-small is 300M params)
- Latency: ~100ms/word (Node), ~300ms (browser WASM)

### Distillation into mini-model (BROWSER-GRADE)

1. Use ByT5 teacher to label a large corpus
2. Train a small (4-layer, 256-hidden) student
3. ~5-10 MB, DER ~3-4%, <20ms/word in browser
- Small enough to bundle in the website by default

## Secryst (Learned Transliteration) — Same Path

### ByT5 fine-tune for Thai → IPA

1. Start from `google/byt5-small`
2. Fine-tune on Wiktionary Thai-IPA pairs
3. Leverages multilingual pretraining
4. Export to ONNX

## Implementation plan

| Step | What | Effort | Timeline |
|------|------|--------|----------|
| 1 | Set up training env (GPU) | 1 day | Week 1 |
| 2 | Clean Tashkeela++ + augmentation | 2 days | Week 1 |
| 3 | Fine-tune ByT5-small on Arabic | 1 day | Week 1 |
| 4 | Evaluate DER | 0.5 day | Week 1 |
| 5 | Export to ONNX + publish | 0.5 day | Week 1 |
| 6 | Integrate into interscript-ts | 1 day | Week 2 |
| 7 | Distill into mini-model | 2 days | Week 2-3 |
| 8 | Fine-tune for Thai-IPA | 1 day | Week 3 |

## References

- ByT5: Xue et al., 2022
- microkimi: https://github.com/serphen/microkimi
- NLLB: Costa-jussà et al., 2022 (shared backbone)
- Distillation: Hinton et al., 2015; Sanh et al., 2019 (DistilBERT)
