# secryst-v2: 05 — Evaluation + benchmark

**Status:** SPECIFICATION
**Priority:** P0

## Same framework as rababa (TODO.rababa/05), different metrics

| Metric | Rababa | Secryst |
|---|---|---|
| Primary | DER (haraqat error rate) | PER (phoneme error rate) |
| Secondary | WER (word error rate) | CER (character error rate) |
| Integration | 3 test vectors in .imp | 11 test vectors in .imp |

## PER implementation

```python
# src/tasks/secryst_thai_ipa/metrics.py
from src.framework.evaluator import BaseEvaluator

class PEREvaluator(BaseEvaluator):
    """Phoneme Error Rate over IPA symbols."""

    def evaluate(self, predictions: list[str], gold: list[str]) -> dict:
        total_errors = 0
        total_symbols = 0
        for pred, true in zip(predictions, gold):
            pred_phonemes = self._parse_ipa(pred)
            true_phonemes = self._parse_ipa(true)
            dist = levenshtein(pred_phonemes, true_phonemes)
            total_errors += dist
            total_symbols += len(true_phonemes)
        per = total_errors / max(total_symbols, 1)
        return {"PER": per, "total_symbols": total_symbols}
```

## Tone accuracy (Thai-specific)

Tone marks (˧ ˦ ˥ ˩ ˨) are the hardest part of Thai→IPA. Track them
separately:
- What % of tone marks are predicted correctly?
- Which tones are most often confused?

## Acceptance

- [ ] PER evaluator implemented and tested
- [ ] Tone accuracy metric implemented
- [ ] Student PER < 20% on test split
- [ ] Comparison report: legacy vs teacher vs student
