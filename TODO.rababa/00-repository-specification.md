# rababa-v2: 00 — Repository specification

**Status:** SPECIFICATION
**Priority:** P0 (first thing to create)

## Repository

```
github.com/interscript/rababa-v2
```

Separate repo from the Ruby gem. The Ruby gem stays as the legacy
runtime; rababa-v2 is the training + export pipeline that produces
ONNX models consumed by interscript-ts.

## Structure (ML project best practices)

```
rababa-v2/
├── README.md                     # What this is, how to reproduce
├── pyproject.toml                # Python deps (uv or poetry)
├── .gitignore                    # data/, models/, __pycache__/, *.onnx
├── .gitattributes                # Git-LFS for .onnx, .safetensors
├── LICENSE                       # MIT (model weights: see model_card)
│
├── data/                         # gitignored — fetched via scripts/
│   ├── raw/                      # Original Tashkeela++ download
│   ├── processed/                # Cleaned + deduplicated
│   └── augmented/                # Synthetic labels from teacher
│
├── src/
│   ├── data/                     # Data pipeline (OCP: each step = one module)
│   │   ├── __init__.py
│   │   ├── download.py           # Fetch Tashkeela++ + OpenDiacritizer
│   │   ├── clean.py              # Strip OCR noise, deduplicate, validate
│   │   ├── encode.py             # Character-level encoding for ByT5
│   │   └── augment.py            # Synthetic data via teacher predictions
│   │
│   ├── models/                   # Model definitions (MECE: one file per arch)
│   │   ├── __init__.py
│   │   ├── teacher_llm.py        # Nemotron-Mini / Phi-3 fine-tune wrapper
│   │   ├── teacher_byt5.py       # ByT5-small fine-tune (alternative teacher)
│   │   └── student.py            # Mini transformer for distillation
│   │
│   ├── training/                 # Training loops (DRY: shared base class)
│   │   ├── __init__.py
│   │   ├── base.py               # BaseTrainer: epoch loop, checkpointing
│   │   ├── finetune.py           # FineTuneTrainer(BaseTrainer)
│   │   ├── distill.py            # DistillTrainer(BaseTrainer)
│   │   └── evaluate.py           # DER / WER metrics
│   │
│   └── export/                   # ONNX export for interscript-ts
│       ├── __init__.py
│       ├── onnx_export.py        # PyTorch → ONNX
│       └── verify.py             # Verify ONNX output matches PyTorch
│
├── scripts/
│   ├── setup_env.sh              # Create venv, install deps
│   ├── fetch_data.sh             # Download all datasets
│   ├── train_teacher.sh          # Full teacher training pipeline
│   ├── train_student.sh          # Full distillation pipeline
│   ├── benchmark.sh              # Run DER + latency benchmarks
│   └── publish.sh                # Upload to HuggingFace Hub
│
├── configs/
│   ├── teacher_nemotron.yaml     # Nemotron-Mini hyperparams
│   ├── teacher_byt5.yaml         # ByT5-small hyperparams
│   ├── student.yaml              # Student model hyperparams
│   └── data.yaml                 # Data pipeline config
│
├── tests/
│   ├── test_data.py              # Data cleaning + encoding
│   ├── test_models.py            # Model forward pass
│   ├── test_der.py               # DER metric calculation
│   └── test_onnx.py              # ONNX export verification
│
├── notebooks/
│   ├── eda.ipynb                 # Exploratory data analysis
│   └── error_analysis.ipynb      # Where does the model fail?
│
└── docs/
    ├── model_card.md             # HuggingFace model card template
    ├── training_log.md           # Experiment log (dates, params, DER)
    └── architecture.md           # Why LLM, not Tacotron
```

## Why a separate repo

- **Clean separation of concerns**: the Ruby gem is a runtime; this is
  a training pipeline. Mixing Python training code into a Ruby gem is
  confusing.
- **Different CI**: Python tests vs Ruby specs, GPU vs CPU runners.
- **Different deps**: PyTorch + transformers vs Ruby + onnx-runtime.
- **Reproducibility**: the repo is self-contained. Anyone can clone +
  `scripts/setup_env.sh && scripts/train_teacher.sh` to reproduce.

## Git-LFS

Models (.onnx, .safetensors) are tracked via Git-LFS:
```bash
git lfs install
git lfs track "*.onnx" "*.safetensors" "*.ckpt"
```

Training data is NOT committed (too large). Fetched via `scripts/fetch_data.sh`.
