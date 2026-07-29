# 19 — `rababa/python` torch 1.9 → 2.x

**Status:** DEFERRED — model compatibility unknown

## Why
- `requirements.txt` pins `torch==1.9.0` (2021 release)
- Python 3.11+ requires torch 2.x
- CI matrix stuck at Python 3.9 because of this

## Risk
- Trained model weights (`.pt` files) were saved with torch 1.x serializers
- torch 2.x can usually load 1.x weights, but `torch.load(weights_path)` may emit warnings or fail for unsafe picks
- ONNX export pipeline (`convert_torch_model_to_onnx.py`) may need updates

## Plan
1. Bump requirements.txt in both `python/arabic/` and `python/hebrew/`:
   ```
   torch>=2.2,<3
   onnxruntime>=1.17
   onnx>=1.15
   numpy>=1.26  # 1.19.5 incompatible with modern Python
   pandas>=2.0  # 1.1.5 incompatible
   ```
2. Re-validate inference on `diacritization_model_max_len_200.onnx` (current gem artifact)
3. Re-export ONNX if torch format changed
4. Bump Python CI matrix to `[3.11, 3.12, 3.13]`
5. Run `rbc diacritize.py` smoke test against `قطر`

## Effort
L — model compat is the unknown. Could be 1 hour (if weights load) or 2 weeks (if re-training needed).

## Affects
- `rababa/python/arabic/requirements.txt`
- `rababa/python/hebrew/requirements.txt`
- `rababa/.github/workflows/python-arabic.yml` (matrix bump)
- `rababa/python/convert_torch_model_to_onnx.py` (ONNX export)

## Related
TODO 08 — ruff baseline for rababa/python (uses Python 3.11 in lint job but Python 3.9 in infer/train jobs)
