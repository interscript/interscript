# 94 — Quantize Rababa model to int8

**Status:** P1
**Depends on:** #93

## Why

Current model: 60 MB unquantized. int8 quantization → ~15 MB.
4× smaller download, same accuracy. No retraining needed.

## Steps

```bash
pip install onnxruntime

python -m onnxruntime.quantization.quantize \
  --input diacritization_model_max_len_200.onnx \
  --output diacritization_model_max_len_200_int8.onnx \
  --quant_format QDQ
```

Verify:
- All 3 test vectors produce identical output
- Output tensor shapes unchanged
- Inference speed unchanged or faster

## Acceptance

- [ ] int8 model produced (~15 MB)
- [ ] Test vectors match unquantized output byte-for-byte
- [ ] Published to HuggingFace alongside the unquantized version
- [ ] Default in provisioner (configurable via modelBase URL)
