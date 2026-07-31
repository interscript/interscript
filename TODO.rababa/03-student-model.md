# rababa-v2: 03 — Student model (distillation for browser)

**Status:** SPECIFICATION
**Priority:** P0

## Goal

Distill the teacher (2-4B params, ~4-8 GB) into a student small enough
to load in a browser WASM runtime: 5-10M params, ~5-10 MB ONNX.

## Architecture

Character-level encoder-decoder transformer (not an LLM):

```python
# src/models/student.py
import torch.nn as nn

class StudentDiacritizer(nn.Module):
    """Mini transformer for character-level diacritization.
    ~5-8M params. Maps input bytes → output bytes with haraqat inserted.
    """
    def __init__(self, vocab_size=256, d_model=256, nhead=4,
                 num_layers=4, dim_ff=1024, max_len=256):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, d_model)
        self.pos_encoding = nn.Parameter(torch.randn(max_len, d_model) * 0.02)
        self.transformer = nn.Transformer(
            d_model=d_model, nhead=nhead,
            num_encoder_layers=num_layers,
            num_decoder_layers=num_layers,
            dim_feedforward=dim_ff,
            dropout=0.1,
            batch_first=True,
        )
        self.output = nn.Linear(d_model, vocab_size)

    def forward(self, src, tgt, src_mask, tgt_mask, src_key_padding_mask, tgt_key_padding_mask):
        src = self.embedding(src) + self.pos_encoding[:src.size(1)]
        tgt = self.embedding(tgt) + self.pos_encoding[:tgt.size(1)]
        out = self.transformer(src, tgt, src_mask, tgt_mask, None,
                               src_key_padding_mask, tgt_key_padding_mask)
        return self.output(out)
```

**Size: ~6M params × 4 bytes = 24 MB unquantized → 6 MB int8.**

## Distillation process

```python
# src/training/distill.py

# 1. Teacher generates labels for a large corpus of undiacritized Arabic
teacher_labels = teacher_model.generate(large_corpus)

# 2. Student learns from teacher's labels (knowledge distillation)
student_loss = cross_entropy(student_logits, teacher_labels) \
             + KL_divergence(student_softmax, teacher_softmax, T=2.0)
```

The student learns the teacher's output distribution, not just the argmax.
This gives it softer training signal → better generalization on rare
patterns.

## Student training config (configs/student.yaml)

```yaml
architecture:
  vocab_size: 256          # UTF-8 byte-level
  d_model: 256
  nhead: 4
  num_layers: 4
  dim_feedforward: 1024
  max_len: 256
  dropout: 0.1
  params_estimate: 6_000_000

training:
  epochs: 50
  batch_size: 64
  learning_rate: 3e-4
  warmup_steps: 1000
  scheduler: cosine
  label_smoothing: 0.1
  teacher_temperature: 2.0
  teacher_weight: 0.7     # weight for KL divergence vs hard labels

data:
  teacher_labels: data/augmented/teacher_labels.jsonl
  gold_labels: data/processed/train.jsonl
  max_length: 200

output: models/student-rababa/
```

## Expected results

| Metric | Teacher | Student | Current Tacotron |
|---|---|---|---|
| DER | 1-2% | 3-4% | 5-7% |
| Size | 4-8 GB | 6 MB | 60 MB |
| Browser latency | N/A | ~20ms | ~500ms |
| Node latency | ~100ms | ~5ms | ~200ms |

## Acceptance

- [ ] Student architecture implemented in PyTorch
- [ ] Distillation loop runs end-to-end
- [ ] DER < 4% on Tashkeela++ test split
- [ ] ONNX export produces <10 MB file
- [ ] ONNX model loads in interscript-ts via onnxruntime-web
- [ ] Browser inference <30ms per word
