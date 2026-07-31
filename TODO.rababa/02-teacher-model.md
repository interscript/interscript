# rababa-v2: 02 — Teacher model (Qwen3.5-4B fine-tune)

**Status:** SPECIFICATION (updated 2026-08-01 — verified latest HuggingFace models)
**Priority:** P0

## Why an LLM, not Tacotron

The current Rababa uses a Tacotron CBHG — a **speech synthesis**
architecture repurposed for text. Its inductive biases (convolution
banks for acoustic features, attention for audio alignment) are wrong
for a pure text task.

A modern Qwen LLM already understands Arabic morphology from pretraining:
- Root patterns (جذر): ق-ط-ر, ك-ت-ب, د-ر-س
- Context-dependent vowel selection (same consonants → different
  haraqat based on meaning)
- Morphological rules (definite article ال, sun letters, etc.)

## Teacher candidates (August 2026 — verified on HuggingFace)

| Model | Params | Downloads | Why |
|---|---|---|---|
| **Qwen3.5-4B** | 4B | 6.3M | Latest dense Qwen. Strong Arabic. LoRA on A100. |
| Qwen3-1.7B | 1.7B | 7.5M | Smaller, faster iteration. Consumer GPU (RTX 4090). |
| Qwen3-4B-Instruct-2507 | 4B | 3.3M | Instruction-tuned. Can prompt zero-shot before fine-tuning. |
| Qwen3.6-35B-A3B | 35B/3B active | 6.1M | MoE — 3B active, very efficient inference. Multi-GPU for training. |
| Qwen2.5-3B-Instruct | 3B | 5.8M | Previous gen. Battle-tested ONNX export. |

**Primary: Qwen3.5-4B** — best Arabic understanding at a trainable size.
**Fallback: Qwen3-1.7B** — faster iteration, consumer GPU.

## Fine-tuning

```python
# src/models/teacher_llm.py
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import LoraConfig, get_peft_model, TaskType

model = AutoModelForCausalLM.from_pretrained(
    "Qwen/Qwen3.5-4B", torch_dtype="auto", device_map="auto",
)
model = get_peft_model(model, LoraConfig(
    task_type=TaskType.CAUSAL_LM, r=16, lora_alpha=32,
    target_modules=["q_proj","v_proj","k_proj","o_proj","gate_proj","up_proj","down_proj"],
    lora_dropout=0.05,
))
```

Config: `configs/teacher_qwen35.yaml` → Qwen3.5-4B, LoRA r=16, bf16, 3 epochs.
