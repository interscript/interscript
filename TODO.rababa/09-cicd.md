# rababa-v2: 09 — CI/CD for the training pipeline

**Status:** SPECIFICATION
**Priority:** P1

## Goal

Reproducible training runs with CI verification. Every model change
goes through automated quality gates before publishing.

## GitHub Actions workflows

### .github/workflows/test.yml (CPU, every PR)
- Lint (ruff)
- Unit tests (pytest)
- Data pipeline integrity checks
- Model forward-pass smoke test (random weights)

### .github/workflows/train.yml (GPU, manual trigger)
- Triggers on: workflow_dispatch (manual), new tag `model-v*`
- Spins up a GPU runner (self-hosted or Lambda Labs)
- Runs full training pipeline: data → fine-tune → distill → evaluate → export
- Uploads model artifact to GitHub Releases
- Uploads to HuggingFace Hub
- Opens a PR to interscript-ts updating the model URL in the manifest

### .github/workflows/benchmark.yml (CPU, weekly)
- Downloads the latest published model
- Runs DER benchmark on Tashkeela++ test split
- Compares with previous week's result
- Alerts if DER regressed > 0.5%

## Model versioning

Semantic versioning for model weights:
- `rababa-student-v2.0.0` — initial release
- `rababa-student-v2.1.0` — retrained with more data (DER improved)
- `rababa-student-v2.0.1` — same weights, ONNX export fix

Version stored in the model manifest (consumed by interscript-ts).

## Acceptance

- [ ] test.yml runs on every PR
- [ ] train.yml produces a model artifact
- [ ] benchmark.yml runs weekly with regression detection
- [ ] Model versioning documented
