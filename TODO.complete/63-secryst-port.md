# 63 — Secryst port (learned transliteration)

**Status:** DEFERRED — needs ONNX model conversion first
**Priority:** P1

## What Secryst does

Learned transliteration for cases where rule tables are insufficient:
script conversions whose output depends on context a regex can't capture
(syllable structure, tone rules, vowel reduction, etc.).

Currently the only active map using it is `var-tha-Thai-Zsym-ipa.imp`
(Thai → IPA). Training data is Wiktionary parallel pairs.

## What to port

| Ruby source | TS port |
|---|---|
| `secryst/lib/secryst/translator.rb` | autoregressive decode loop |
| `secryst/lib/secryst/model.rb` | OnnxModel wrapper |
| `secryst/lib/secryst/vocab.rb` | Vocab tokenization |

The transformer itself is just an ONNX inference call — no architecture
port needed.

## Prerequisite: ONNX export

The Ruby gem already supports both `.pth` (PyTorch via torch.rb) and
`.onnx` formats in its model zip. To use in TS:
1. Take the existing trained `thai-ipa` model
2. Convert to ONNX via `torch.onnx.export` (or use the gem's export path)
3. Publish the converted model to HuggingFace / CDN

## Acceptance

- [ ] All 11 test vectors in `var-tha-Thai-Zsym-ipa.imp` pass
- [ ] Vocab YAML parsing works for any secryst model format
- [ ] Autoregressive decode is bounded by max_seq_length
- [ ] Performance: ≤ 300ms per name on Node
