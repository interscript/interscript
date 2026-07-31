# rababa-v2: 08 — Secryst modernization (same pipeline for Thai→IPA)

**Status:** SPECIFICATION
**Priority:** P1

## Goal

Apply the same modernize-then-distill approach to Secryst, starting
with the Thai → IPA transliteration task.

## Why

Secryst's vanilla transformer has no pretraining. A fine-tuned LLM
leverages multilingual understanding of Thai characters, tone rules,
and phonological patterns that the from-scratch transformer must learn
from scratch.

## Data

- **Wiktionary Thai-IPA pairs**: ~10K parallel entries (already used
  by the Ruby secryst map)
- **Synthetic**: use existing rule-based Thai transliteration maps to
  generate "noisy" pairs, then have the teacher correct them
- **Tone-marked text corpora**: Thai text with explicit tone annotation
  from linguistic resources

## Pipeline (reuses rababa-v2 infrastructure)

```
rababa-v2/                ← Arabic diacritization
secryst-v2/               ← Thai → IPA (NEW — same structure)
├── src/
│   ├── data/
│   │   ├── download_wiktionary.py
│   │   ├── clean_thai.py
│   │   └── augment_thai.py
│   ├── models/
│   │   ├── teacher_llm.py      # same LLM fine-tune, different prompt
│   │   └── student.py          # same architecture
│   ├── training/
│   │   ├── finetune.py
│   │   ├── distill.py
│   │   └── evaluate.py         # phoneme error rate instead of DER
│   └── export/
│       └── onnx_export.py
├── configs/
│   ├── teacher_thai.yaml
│   └── student_thai.yaml
└── docs/
    └── model_card.md
```

## Teacher fine-tune prompt

```
Transliterate the following Thai text to IPA (International Phonetic Alphabet):
คฺวาม-วาว
---
kʰwaːm˧.waːw˧
```

The LLM learns to produce IPA from Thai characters. Its multilingual
pretraining already includes IPA notation (from Wikipedia phonetic
transcriptions).

## Evaluation

- **Phoneme Error Rate (PER)**: fraction of IPA symbols predicted wrong
- **Tone accuracy**: fraction of tone marks (˧˦˥˩) predicted correctly
- These are more relevant than DER for cross-script transliteration

## Acceptance

- [ ] Thai-IPA training data pipeline built
- [ ] Teacher fine-tuned with PER < 15%
- [ ] Student distilled and exported to ONNX (<10 MB)
- [ ] All 11 test vectors from var-tha-Thai-Zsym-ipa.imp pass
- [ ] Published to HuggingFace with model card
