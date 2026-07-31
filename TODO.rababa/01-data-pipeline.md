# rababa-v2: 01 — Data pipeline

**Status:** SPECIFICATION
**Priority:** P0

## Goal

Build a clean, reproducible data pipeline that produces training-ready
datasets for Arabic diacritization.

## Sources

### Primary: Tashkeela++
- ~50M Arabic words with full diacritization
- Cleaned version of the original Tashkeela corpus
- Source: https://huggingface.co/datasets (search "tashkeela")
- Format: tab-separated (undiacritized | diacritized)

### Secondary: OpenDiacritizer corpus
- ~2M sentences from Arabic Wikipedia + news
- Automatically diacritized (silver labels)
- Source: https://github.com/almodhfer/OpenDiacritizer

### Synthetic augmentation
- Take undiacritized Arabic from large corpora (CC-100, OSCAR)
- Run the teacher model to generate silver labels
- Mix gold (Tashkeela++) + silver 60/40

## Pipeline stages

```
download.py   →  raw data in data/raw/
     ↓
clean.py      →  validated pairs in data/processed/
     ↓
encode.py     →  tokenized tensors in data/processed/*.pt
     ↓
augment.py    →  silver-labeled data in data/augmented/
```

### clean.py rules
- Remove entries with non-Arabic characters (keep haraqat + basic punctuation)
- Remove entries shorter than 3 chars or longer than 200 chars
- Deduplicate by (input, output) pair
- Validate: stripped input + haraqat ≈ output (consistency check)
- Split: 90% train, 5% validation, 5% test (deterministic seed)

### encode.py

For LLM teachers (Nemotron/Phi-3):
- Use the model's native tokenizer
- Format as chat/instruction: "Add harakat to the following Arabic text: {input}"
- Target: the diacritized text

For ByT5 teacher:
- Character-level: every byte is a token
- No special formatting needed

## Acceptance

- [ ] `scripts/fetch_data.sh` downloads all sources
- [ ] `src/data/clean.py` produces deduplicated, validated splits
- [ ] `src/data/encode.py` produces tokenized tensors
- [ ] `tests/test_data.py` verifies data integrity
- [ ] DER baseline computed on cleaned Tashkeela++ test split
