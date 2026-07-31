# rababa-v2: 06 — HuggingFace publishing + model card

**Status:** SPECIFICATION
**Priority:** P1

## Goal

Publish trained models to HuggingFace Hub with proper model cards so
the community can verify provenance, evaluate independently, and
reproduce.

## Repositories

```
huggingface.co/interscript/rababa-teacher-qwen    # 2-4B teacher
huggingface.co/interscript/rababa-student-v2       # 5-10M distilled student
huggingface.co/interscript/rababa-legacy-tacotron  # 60MB legacy (for parity)
```

## Model card template (docs/model_card.md)

```markdown
---
license: mit
language:
  - ar
tags:
  - arabic
  - diacritization
  - harakat
  - onnx
  - interscript
base_model: Qwen/Qwen2.5-3B
pipeline_tag: text2text-generation
---

# Rababa v2 — Arabic Diacritization (Student)

## Description
Distilled student model for Arabic diacritization. Adds harakat
(vowel marks) to undiacritized Arabic text.

## Architecture
4-layer character-level transformer, distilled from a Qwen2.5-3B
teacher fine-tuned on Tashkeela++.

## Inputs / Outputs
- Input: undiacritized Arabic text (UTF-8 bytes)
- Output: diacritized Arabic text with haraqat

## Performance
| Metric | Value |
|---|---|
| DER | 3.2% |
| WER | 8.1% |
| Size | 6.4 MB |
| Latency (Node) | 5ms/word |
| Latency (WASM SIMD) | 22ms/word |

## Training data
- Tashkeela++ (50M words, gold labels)
- Synthetic augmentation from teacher (100M words, silver labels)

## Limitations
- Max input length: 200 characters
- Trained on MSA (Modern Standard Arabic); dialect performance varies
- No transliteration — use with interscript for that

## Citation
```
@misc{interscript-rababa-v2,
  title={Rababa v2: Modern Arabic Diacritization},
  author={Interscript Contributors},
  year={2026},
  url={https://github.com/interscript/rababa-v2}
}
```

## License
MIT (code) + CC-BY-4.0 (model weights)
```

## Publishing script

```bash
# scripts/publish.sh
huggingface-cli login --token $HF_TOKEN

# Upload student model
huggingface-cli upload interscript/rababa-student-v2 \
  models/student-rababa/student.onnx \
  --commit-message "v2.0 student model (DER 3.2%)"

huggingface-cli upload interscript/rababa-student-v2 \
  docs/model_card.md \
  --commit-message "model card"
```

## interscript-ts integration

After publishing:
```typescript
setModelBase("https://huggingface.co/interscript/interscript-models/resolve/main")
// rababa/200/model.onnx → legacy Tacotron
// rababa/200/student-v2.onnx → new student
```

## Acceptance

- [ ] HuggingFace org `interscript` created
- [ ] All 3 model repos published with model cards
- [ ] Direct download URLs work from interscript-ts
- [ ] Model card includes DER, WER, size, latency
- [ ] Citation block + license documented
