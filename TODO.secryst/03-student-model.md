# secryst-v2: 03 — Student model (shared architecture with rababa)

**Status:** SPECIFICATION
**Priority:** P0

## Architecture

Identical to `TODO.rababa/03-student-model.md`. The same 6M-param
character-level transformer:

```python
StudentDiacritizer(  # rename to StudentTransformer
  vocab_size=256,    # UTF-8 byte-level — covers both Thai AND IPA
  d_model=256, nhead=4, num_layers=4, dim_ff=1024, max_len=256,
)
```

The student is script-agnostic. It maps input bytes → output bytes.
Whether those bytes encode Arabic+haraqat or Thai+IPA is irrelevant
to the architecture — only the training data differs.

## Distillation

Same process as rababa:
1. Teacher (Qwen3.5-4B fine-tuned on Thai→IPA) generates labels
2. Student trains on teacher's output distribution (KL divergence)
3. Export to ONNX (~6 MB)

## Config

```yaml
# configs/student_thai_ipa.yaml
architecture:
  vocab_size: 256
  d_model: 256
  nhead: 4
  num_layers: 4
  dim_feedforward: 1024
  max_len: 256
training:
  epochs: 100
  batch_size: 64
  learning_rate: 3e-4
  teacher_temperature: 2.0
output: models/student-thai-ipa/
```

## Evaluation

Phoneme Error Rate (PER) instead of DER:
```python
def per(predicted_ipa: str, gold_ipa: str) -> float:
    """Phoneme Error Rate: edit distance over IPA symbols."""
    pred_symbols = parse_ipa(predicted_ipa)  # split into phoneme units
    gold_symbols = parse_ipa(gold_ipa)
    return levenshtein(pred_symbols, gold_symbols) / len(gold_symbols)
```

## Acceptance

- [ ] Same student architecture as rababa (DRY — one class)
- [ ] Distilled model achieves PER < 20%
- [ ] All 11 map test vectors pass
- [ ] ONNX < 10 MB
- [ ] Browser inference < 30ms/word
