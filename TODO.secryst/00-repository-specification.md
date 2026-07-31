# secryst-v2: 00 — Repository specification (unified with rababa-v2)

**Status:** SPECIFICATION
**Priority:** P0

## Unified repo

Secryst and Rababa share one training repo: `interscript/ml-models`.

See `TODO.rababa/10-unified-framework.md` for the full structure. This
file documents the secryst-specific aspects.

## Secryst task definitions

Each secryst task lives in `src/tasks/secryst_<source>_<target>/`:

```
src/tasks/
├── secryst_thai_ipa/          # Thai → IPA (the active map)
│   ├── config.yaml            # task-specific hyperparams
│   ├── data.py                # ThaiIPAData(DataModule)
│   ├── prompts.py             # LLM instruction format
│   └── metrics.py             # PEREvaluator(BaseEvaluator)
├── secryst_khmer_ipa/         # Khmer → IPA (future)
│   └── ...
├── secryst_amharic_latin/     # Amharic → Latin (future)
│   └── ...
```

## Shared framework (see TODO.rababa/10)

Both rababa and secryst use:
- `src/framework/data.py` — DataModule base
- `src/framework/model.py` — ModelModule base (teacher + student)
- `src/framework/trainer.py` — BaseTrainer (fine-tune + distill)
- `src/framework/exporter.py` — ONNX export
- `src/framework/evaluator.py` — BaseEvaluator

## What differs per task

| Aspect | Rababa (diacritization) | Secryst (transliteration) |
|---|---|---|
| Input script | Arabic/Hebrew | Thai/Khmer/etc. |
| Output script | Same + haraqat | IPA/Latin |
| Metric | DER | PER (phoneme error rate) |
| Teacher prompt | "Add harakat" | "Transliterate to IPA" |
| Training data | Tashkeela++ | Wiktionary pairs |
| Map integration | `rababa config: "200"` | `secryst model: "thai-ipa"` |

The differences are **config + data only**. The training pipeline is
identical. This is the core of the unification.
