# rababa-v2: 10 — Unified ML training framework (shared with secryst)

**Status:** SPECIFICATION
**Priority:** P0

## Goal

One training framework for ALL ML-powered interscript models. Rababa
(Arabic/Hebrew diacritization) and Secryst (Thai→IPA transliteration)
share the same pipeline. Each task is a **config + dataset**, not a
separate codebase.

## Unified repo: `interscript/ml-models`

```
interscript/ml-models/
├── src/
│   ├── framework/             # SHARED — both rababa and secryst use this
│   │   ├── __init__.py
│   │   ├── config.py          # TaskConfig dataclass (loaded from YAML)
│   │   ├── pipeline.py        # TrainingPipeline orchestrator
│   │   ├── data.py            # DataModule base class (OCP: new sources = subclass)
│   │   ├── model.py           # ModelModule base class (OCP: new arch = subclass)
│   │   ├── trainer.py         # BaseTrainer (DRY: shared epoch loop)
│   │   ├── evaluator.py       # BaseEvaluator (DER, PER, WER metrics)
│   │   └── exporter.py        # ONNX export + verification
│   │
│   ├── tasks/                 # TASK-SPECIFIC — one directory per task
│   │   ├── rababa_arabic/     # Arabic diacritization
│   │   │   ├── config.yaml
│   │   │   ├── data.py        # RababaArabicData(DataModule)
│   │   │   ├── prompts.py     # Instruction format for LLM teacher
│   │   │   └── metrics.py     # DER implementation
│   │   ├── rababa_hebrew/     # Hebrew diacritization
│   │   │   ├── config.yaml
│   │   │   └── data.py
│   │   └── secryst_thai_ipa/  # Thai → IPA transliteration
│   │       ├── config.yaml
│   │       ├── data.py
│   │       └── metrics.py     # PER implementation
│   │
│   └── cli.py                 # `python -m src.cli train --task rababa_arabic`
│
├── models/                    # Output directory (gitignored, git-LFS)
├── configs/                   # Shared default configs
├── scripts/                   # setup, train, publish
├── tests/                     # Framework + task tests
└── docs/
```

## Key abstractions (OCP/MECE/DRY)

```python
# src/framework/data.py — MECE: data source knows nothing about model
class DataModule(ABC):
    @abstractmethod
    def prepare_data(self) -> None: ...
    @abstractmethod
    def train_dataloader(self) -> DataLoader: ...
    @abstractmethod
    def val_dataloader(self) -> DataLoader: ...

# src/framework/model.py — MECE: model knows nothing about data source
class ModelModule(ABC):
    @abstractmethod
    def forward(self, batch) -> Loss: ...
    @abstractmethod
    def generate(self, input_ids) -> output_ids: ...

# src/framework/trainer.py — DRY: shared training loop
class BaseTrainer:
    def fit(self, model: ModelModule, data: DataModule): ...
    def distill(self, teacher: ModelModule, student: ModelModule, data: DataModule): ...

# src/framework/evaluator.py — OCP: new metric = new subclass
class BaseEvaluator(ABC):
    @abstractmethod
    def evaluate(self, predictions, gold) -> dict: ...

class DEREvaluator(BaseEvaluator): ...  # rababa
class PEREvaluator(BaseEvaluator): ...  # secryst
```

## Adding a new task

1. Create `src/tasks/<name>/config.yaml`
2. Create `src/tasks/<name>/data.py` extending `DataModule`
3. (Optional) Create `src/tasks/<name>/metrics.py` extending `BaseEvaluator`
4. Run: `python -m src.cli train --task <name>`

Zero edits to framework code. **OCP**.

## Acceptance

- [ ] Framework modules implement all abstractions
- [ ] rababa_arabic task configured and runnable
- [ ] rababa_hebrew task configured
- [ ] secryst_thai_ipa task configured
- [ ] Tests cover framework + each task
