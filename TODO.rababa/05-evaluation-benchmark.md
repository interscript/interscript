# rababa-v2: 05 — Evaluation + benchmark suite

**Status:** SPECIFICATION
**Priority:** P0

## Goal

Comprehensive evaluation harness comparing:
- Legacy Tacotron (current baseline)
- LLM teacher (Nemotron/Phi-3/Qwen fine-tune)
- Distilled student (browser-grade)
- Ruby Rababa (reference implementation)

## Metrics

### DER (Diacritization Error Rate)
Primary metric. Fraction of haraqat positions predicted incorrectly.
Lower is better. Industry SOTA: ~2%.

### WER (Word Error Rate)
Fraction of words with at least one wrong haraqat.
More user-relevant than DER (a word is "wrong" if any haraqat is off).

### Latency
- Node: `onnxruntime-node` inference time per word
- Browser: `onnxruntime-web` WASM SIMD time per word
- Browser (WebGPU): same with WebGPU execution provider

### Size
ONNX file size (unquantized). Lower is better for browser deployment.

## Benchmark datasets

| Dataset | Size | Purpose |
|---|---|---|
| Tashkeela++ test split | ~25K words | Primary DER benchmark |
| var-ara-Arab-Arab-rababa.imp test vectors | 3 vectors | Integration test |
| Arabic Wikipedia sample | 1K sentences | Real-world text |
| News articles (Al Jazeera) | 500 articles | Domain shift test |

## Script

```bash
# scripts/benchmark.sh
python -m src.training.evaluate \
  --model models/teacher-qwen-rababa/ \
  --test-data data/processed/test.jsonl \
  --report docs/benchmark-report-teacher.md

python -m src.training.evaluate \
  --model models/student-rababa/student.onnx \
  --test-data data/processed/test.jsonl \
  --report docs/benchmark-report-student.md

# Compare all models side-by-side
python -m src.training.evaluate \
  --compare models/legacy-tacotron models/teacher-qwen models/student \
  --test-data data/processed/test.jsonl \
  --report docs/benchmark-comparison.md
```

## Acceptance

- [ ] DER metric implemented and unit-tested
- [ ] All 4 model variants evaluated on all 4 datasets
- [ ] Comparison report generated as markdown
- [ ] Student DER < 4% on Tashkeela++ test split
- [ ] Student browser latency < 30ms/word
- [ ] Student ONNX < 10 MB
