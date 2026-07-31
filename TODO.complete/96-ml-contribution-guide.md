# 96 — Community: ML model contribution guide

**Status:** P2
**Depends on:** #93

## Goal

Document how to contribute a new ML model to Interscript. Lowers the
barrier for linguists/ML researchers who want to add learned
transliteration for their language.

## Guide structure

1. **When to use ML vs rules** — rule tables are cheaper and
   deterministic. Only use ML when the mapping can't be captured
   by a finite state machine (tone rules, vowel reduction, etc.)
2. **Training data** — parallel pairs (source → target). Sources:
   Wiktionary, published corpora, synthetic augmentation from rule maps
3. **Model format** — ONNX export, max 100MB unquantized, ≤25MB int8
4. **Integration** — register in `src/ml/models/<name>/`, add to manifest
5. **Testing** — at least 10 test vectors in the map file
6. **Hosting** — publish to HuggingFace, add to model manifest

## Acceptance

- [ ] `/contributing/ml` page on website
- [ ] Template model repo on HuggingFace
- [ ] Step-by-step with code examples
- [ ] Link from `/contributing` main page
