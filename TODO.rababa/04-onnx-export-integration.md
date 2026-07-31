# rababa-v2: 04 — ONNX export + interscript-ts integration

**Status:** SPECIFICATION
**Priority:** P0

## Goal

Export the trained student model to ONNX format, verify it loads in
interscript-ts, and update the ML module to use it.

## Export pipeline

```python
# src/export/onnx_export.py
import torch
from optimum.onnxruntime import ORTModelForSeq2SeqLM
from src.models.student import StudentDiacritizer

model = StudentDiacritizer()
model.load_state_dict(torch.load("models/student-rababa/best.pt"))
model.eval()

# Create dummy input for tracing
dummy_src = torch.randint(0, 256, (1, 200), dtype=torch.long)
dummy_tgt = torch.randint(0, 256, (1, 10), dtype=torch.long)
dummy_masks = ...

# Export
torch.onnx.export(
    model,
    (dummy_src, dummy_tgt, *dummy_masks),
    "models/student-rababa/student.onnx",
    input_names=["src", "tgt", "src_mask", "tgt_mask",
                 "src_key_padding_mask", "tgt_key_padding_mask"],
    output_names=["logits"],
    dynamic_axes={
        "src": {0: "batch", 1: "seq"},
        "tgt": {0: "batch", 1: "seq"},
        "logits": {0: "batch", 1: "seq"},
    },
    opset_version=17,
)
```

## Verification

```python
# src/export/verify.py
# Run the same input through both PyTorch and ONNX, compare outputs
# Max absolute difference must be < 1e-4
```

## interscript-ts integration

The student is a seq2seq transformer (like Secryst). Integration:
1. The ONNX model's input/output names match the Secryst session interface
2. Register as a new model kind: `rababa-llm` (distinct from legacy
   `rababa` Tacotron)
3. The ML module auto-detects which model to use based on map config

```typescript
// src/ml/models/rababa-llm/index.ts
registerModel("rababa-llm", async (params) => {
  // Same autoregressive decode as Secryst, but byte-level
  const session = params.session
  const decoder = new ByteLevelDecoder(session)
  return new RababaLLMModel(session, decoder)
})
```

## Backward compatibility

The legacy `rababa` (Tacotron) stays registered for users who want it.
Maps can specify which model:
```ruby
# In the .imp file:
rababa config: "200"              # legacy Tacotron (default)
rababa config: "200", model: "llm"  # new LLM-distilled student
```

## Acceptance

- [ ] ONNX export script produces a valid model file
- [ ] PyTorch ↔ ONNX output difference < 1e-4
- [ ] interscript-ts loads the ONNX via onnxruntime-node
- [ ] All 3 test vectors from var-ara-Arab-Arab-rababa.imp pass
- [ ] No regression in non-ML maps
