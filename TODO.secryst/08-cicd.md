# secryst-v2: 08 — CI/CD (shared with rababa-v2)

**Status:** SPECIFICATION
**Priority:** P1

## Same CI/CD as rababa (TODO.rababa/09)

The unified repo `interscript/ml-models` has one CI pipeline. Each task
is a matrix entry:

```yaml
# .github/workflows/train.yml
jobs:
  train:
    strategy:
      matrix:
        task:
          - rababa_arabic
          - rababa_hebrew
          - secryst_thai_ipa
    steps:
      - run: python -m src.cli train --task ${{ matrix.task }}
```

## Per-task quality gates

Each task has its own DER/PER threshold in the config:
```yaml
# configs/secryst_thai_ipa.yaml
evaluation:
  metric: PER
  max_threshold: 0.20  # fail if PER > 20%
```

CI fails if any task exceeds its threshold.

## Acceptance

- [ ] All tasks run via the same workflow
- [ ] Per-task quality gates enforced
- [ ] Model artifacts uploaded to HuggingFace on success
