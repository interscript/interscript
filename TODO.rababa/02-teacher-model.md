# rababa-v2: 02 — Teacher model (Nemotron-Mini / Phi-3 fine-tune)

**Status:** SPECIFICATION
**Priority:** P0

## Why an LLM, not Tacotron

The current Rababa uses a Tacotron CBHG — a **speech synthesis**
architecture repurposed for text. Its inductive biases (convolution
banks for acoustic features, attention for audio alignment) are wrong
for a pure text task.

A modern small LLM (Nemotron-Mini, Phi-3-mini, Gemma-2-2B) already
understands Arabic morphology from pretraining:
- Root patterns (جذر): ق-ط-ر, ك-ت-ب, د-ر-س
- Context-dependent vowel selection (same consonants → different
  haraqat based on meaning)
- Morphological rules (definite article ال, sun letters, etc.)

Diacritization is: "given these consonants + context, predict vowels."
That's exactly what a language model does.

## Teacher candidates (2026)

| Model | Params | Arabic pretraining | License | Inference |
|---|---|---|---|---|
| **Nemotron-Mini-4B** | 4B | Yes (NVIDIA multilingual) | NVIDIA Open | NeMo / vLLM |
| **Phi-3-mini-4K** | 3.8B | Moderate | MIT | ONNX export native |
| **Gemma-2-2B** | 2B | Yes (Google multilingual) | Gemma License | TFLite / ONNX |
| **Qwen2.5-3B** | 3B | Yes (strong Arabic) | Apache 2.0 | vLLM / ONNX |

**Recommended: Qwen2.5-3B or Gemma-2-2B** — strongest Arabic understanding
at ≤3B params. Both export cleanly to ONNX.

**Alternative: Nemotron-Mini-4B** — if NVIDIA NeMo pipeline is preferred.

## Fine-tuning approach

```python
# src/models/teacher_llm.py
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments
from peft import LoraConfig, get_peft_model

model_name = "Qwen/Qwen2.5-3B"  # or "google/gemma-2-2b"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

# LoRA: train only 0.5% of params (fast, memory-efficient)
lora_config = LoraConfig(
    task_type="CAUSAL_LM",
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
)
model = get_peft_model(model, lora_config)

# Training prompt format:
# "Add full harakat (diacritics) to this Arabic text:\nقطر\n---\nقِطْرَ"
# The model learns to generate the diacritized form.
```

### Fine-tune config (configs/teacher_qwen.yaml)

```yaml
model: Qwen/Qwen2.5-3B
method: lora
lora:
  r: 16
  alpha: 32
  dropout: 0.05
training:
  epochs: 3
  batch_size: 16
  gradient_accumulation: 4
  learning_rate: 2e-4
  warmup_steps: 100
  fp16: true
data:
  train_split: data/processed/train.jsonl
  val_split: data/processed/val.jsonl
  max_length: 512
output: models/teacher-qwen-rababa/
```

## Evaluation

```python
# src/training/evaluate.py
def der(predicted: str, gold: str) -> float:
    """Diacritization Error Rate: fraction of incorrectly predicted haraqat."""
    # Align by character (strip non-haraqat for alignment)
    # Count mismatches in haraqat positions
    ...

# Target: DER < 3% on Tashkeela++ test split
```

## Acceptance

- [ ] Fine-tuning script runs end-to-end on single A100
- [ ] DER < 3% on Tashkeela++ test split
- [ ] All 3 test vectors from var-ara-Arab-Arab-rababa.imp pass
- [ ] Model checkpoint saved to `models/teacher-qwen-rababa/`
- [ ] Training log documents: epochs, learning rate, DER curve
