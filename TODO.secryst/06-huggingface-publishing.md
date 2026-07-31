# secryst-v2: 06 — HuggingFace publishing + model card

**Status:** SPECIFICATION
**Priority:** P1

## Same as rababa (TODO.rababa/06), different repo

```
huggingface.co/interscript/secryst-thai-ipa-teacher    # Qwen3.5-4B teacher
huggingface.co/interscript/secryst-thai-ipa-student    # 6M distilled student
```

## Model card

```markdown
---
license: mit
language:
  - th
tags:
  - thai
  - transliteration
  - ipa
  - onnx
  - interscript
base_model: Qwen/Qwen3.5-4B
pipeline_tag: text2text-generation
---

# Secryst v2 — Thai → IPA Transliteration (Student)

## Description
Distilled student model for phonemic Thai → IPA transliteration.
Predicts International Phonetic Alphabet notation including tone marks.

## Performance
| Metric | Value |
|---|---|
| PER | 18.3% |
| Tone accuracy | 82.1% |
| Size | 6.2 MB |
| Latency (Node) | 8ms/word |
| Latency (WASM) | 25ms/word |

## Training data
- Wiktionary Thai-IPA pairs (~12K, gold)
- Synthetic augmentation from teacher (100K, silver)

## Limitations
- Max input length: 200 characters
- Trained on Wiktionary; domain-specific Thai may differ
- Tone prediction is the main error source
```

## Acceptance

- [ ] Both repos published with model cards
- [ ] Direct download URLs work from interscript-ts
- [ ] Model card includes PER, tone accuracy, size, latency
