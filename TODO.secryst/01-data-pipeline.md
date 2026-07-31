# secryst-v2: 01 — Thai → IPA data pipeline

**Status:** SPECIFICATION
**Priority:** P0

## Sources

### Primary: Wiktionary Thai-IPA extraction
- Parse Wiktionary entries that have both Thai script and IPA
- ~10K-15K parallel pairs (enough for fine-tuning with pre-trained LLM)
- Source: https://en.wiktionary.org/wiki/Category:Thai_terms_with_IPA_pronunciation
- Scraper: `src/tasks/secryst_thai_ipa/data.py:download_wiktionary()`

### Secondary: existing test vectors
- The 11 test vectors in `var-tha-Thai-Zsym-ipa.imp` serve as held-out test
- Never used in training — pure evaluation

### Synthetic augmentation
- Take undiacritized Thai text from Thai Wikipedia / OSCAR
- Run existing rule-based Thai maps to get approximate transliterations
- Use the teacher model to "correct" these — creates silver-label pairs
- Mix gold (Wiktionary) + silver 50/50

## Data format

```jsonl
{"input": "คฺวาม-วาว", "output": "kʰwaːm˧.waːw˧"}
{"input": "ที่-เปิด-ขวด", "output": "tʰiː˥˩.pɤːt̚˨˩.kʰua̯t̚˨˩"}
```

Character-level input (Thai chars), character-level output (IPA chars).
No special tokenization — ByT5/Qwen handles raw bytes.

## Pipeline (reuses framework)

```
DataModule.prepare_data()
  → download wiktionary dump
  → parse entries with Thai + IPA
  → clean: remove entries with missing IPA, normalize Unicode
  → split: 90% train / 5% val / 5% test
  → augment with synthetic data
```

## Acceptance

- [ ] Wiktionary scraper produces ≥10K clean parallel pairs
- [ ] All 11 map test vectors excluded from training data
- [ | Synthetic augmentation pipeline works
- [ ] Data integrity tests pass
