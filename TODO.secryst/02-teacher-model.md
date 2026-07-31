# secryst-v2: 02 — Teacher model (Qwen3.5-4B for Thai→IPA)

**Status:** SPECIFICATION
**Priority:** P0

## Approach

Same as rababa (see `TODO.rababa/02-teacher-model.md`) but with
Thai-specific prompts. The Qwen3.5-4B model already understands Thai
characters and IPA notation from pretraining.

## Fine-tune prompt

```
<|im_start|>system
Transliterate the following Thai text to IPA (International Phonetic
Alphabet) notation. Use tone marks (˧ ˦ ˥ ˩ ˨) where appropriate.<|im_end|>
<|im_start|>user
คฺวาม-วาว<|im_end|>
<|im_start|>assistant
kʰwaːm˧.waːw˧<|im_end|>
```

## Config

```yaml
# configs/teacher_qwen35_thai.yaml
model: Qwen/Qwen3.5-4B
method: lora
lora:
  r: 16
  alpha: 32
  target_modules: [q_proj, v_proj, k_proj, o_proj, gate_proj, up_proj, down_proj]
training:
  epochs: 5         # more epochs — less data than rababa
  batch_size: 8
  gradient_accumulation: 4
  learning_rate: 3e-4  # slightly higher — smaller dataset
  bf16: true
data:
  train_split: data/processed/thai_ipa_train.jsonl
  val_split: data/processed/thai_ipa_val.jsonl
output: models/teacher-qwen35-thai-ipa/
```

## Why Qwen3.5-4B works for Thai

- Qwen models are developed by Alibaba — strong Asian language support
- Thai is well-represented in Qwen pretraining data
- IPA notation appears in Wikipedia phonetic transcriptions (pretraining)
- The 4B model has enough capacity to learn tone rules from ~10K examples

## Acceptance

- [ ] Fine-tuning runs on single A100
- [ ] PER < 15% on held-out Wiktionary test split
- [ ] All 11 map test vectors pass (exact match)
- [ ] Model checkpoint saved
