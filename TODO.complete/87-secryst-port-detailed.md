# 87 — Secryst port (learned transliteration transformer)

**Status:** P0
**Depends on:** #85 (async executor)

## Goal

Port the Secryst transformer decoder to TS so `var-tha-Thai-Zsym-ipa`
and any future secryst map works via `transliterateAsync`.

## What to port

| Ruby source | TS port | Lines |
|---|---|---|
| `secryst/lib/secryst/translator.rb` | `src/ml/models/secryst/translator.ts` | ~60 |
| `secryst/lib/secryst/model.rb` (Onnx class) | `src/ml/models/secryst/onnx-model.ts` | ~30 |
| `secryst/lib/secryst/vocab.rb` | `src/ml/models/secryst/vocab.ts` | ~40 |

## Architecture

```
src/ml/models/secryst/
├── index.ts              # registration: registerModel("secryst", factory)
├── vocab.ts              # Vocab class: stoi/itos maps, YAML parsing
├── translator.ts         # autoregressive decode loop
└── masks.ts              # attention mask construction
```

## Autoregressive decode loop

Direct port from `translator.rb:translate`:
```
1. Encode input: chars → vocab IDs, prepend <sos>, append <eos>
2. Initialize output: [<sos>]
3. Loop (max_seq_length times):
   a. Construct masks (causal/attention/padding)
   b. Run ONNX inference: {src, tgt, masks} → logits
   c. Argmax → next token ID
   d. If <eos>: break
   e. Append token to output
4. Decode output IDs → chars via target vocab
```

## Vocab format

Secryst models ship with `vocabs.yaml` in the model zip:
```yaml
input:
  - "<sos>"
  - "<eos>"
  - "a"
  - "b"
  ...
target:
  - "<sos>"
  - "<eos>"
  - "x"
  - "y"
  ...
```

Parsed via `js-yaml` (lightweight, ~30KB).

## Model input names (from Ruby source)

The ONNX model expects:
- `src`: source token IDs [batch, src_len]
- `tgt`: target token IDs so far [batch, tgt_len]
- `tgt_mask`: causal attention mask [tgt_len, tgt_len]
- `src_key_padding_mask`: padding mask for source [batch, src_len]
- `tgt_key_padding_mask`: padding mask for target [batch, tgt_len]
- `memory_key_padding_mask`: same as src_key_padding_mask

## Acceptance

- [ ] Vocab parses correctly from YAML
- [ ] Mask construction matches Ruby logic
- [ ] Autoregressive decode loop terminates on <eos>
- [ ] Output matches Ruby for at least one test vector
- [ ] Max sequence length enforced
