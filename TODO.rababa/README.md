# ML Modernization Plan — Unified Schedule

**Goal:** One interface (`transliterateAsync`) for every Interscript map,
including ML-powered ones (rababa, secryst). Train modern LLM-based
models to replace the legacy Tacotron/vanilla-transformer.

## Where the code lives

**Implementation:** https://github.com/interscript/ml-models

This monorepo (`TODO.rababa/`, `TODO.secryst/`) holds the **specs and
schedule**. The framework + task packages live in the separate
`interscript/ml-models` repo (sibling layout under
`/Users/mulgogi/src/interscript/ml-models/`). Distribution plan is in
`TODO.distribution/` in that repo.

## Architecture decision

**Direct supervised training of a ~30M param character-level transformer
on the gold corpus.** No LLM teacher.

For diacritization, the corpus is authoritative. Tashkeela++ is
~2M verses of scholar-annotated Arabic with full harakat. An LLM
teacher fine-tuned on the same corpus can't add information the
corpus doesn't already have — it only adds noise + cost.

Two tiers:
- **Tier 1 (default)**: ~30M char transformer, self-pretrained on
  unlabeled Arabic then fine-tuned on Tashkeela++. ~$10-15/task.
  DER 4-6%. Browser at q8 (~8MB).
- **Tier 2 (optional quality)**: distill from a fine-tuned ByT5-base
  teacher (also trained on Tashkeela++) into the same 30M student.
  ~$25-35/task. DER 3-4%.

The teacher in Tier 2 is *also* a student of Tashkeela++, not an LLM
with prior opinions. Distillation here is a *compression* strategy,
not a *labeling* strategy.

See `ml-models/docs/architecture.md` for the full ADR.

A CPU-only `StudentTrainer` exists for dev / CI / mobile variants —
it trains the student directly on gold labels on a laptop.

## Unified repository

One repo trains ALL models: `interscript/ml-models`

```
src/tasks/
├── rababa_arabic/      # Arabic diacritization (replaces Tacotron)
├── rababa_hebrew/      # Hebrew diacritization (nikud)
├── secryst_thai_ipa/   # Thai → IPA (replaces vanilla transformer)
└── [future tasks]      # Khmer, Japanese, Chinese...
```

Each task = one config + one data module. Shared framework. OCP.

## Prioritized schedule

| Phase | Items | Status | Est. |
|---|---|---|---|
| **P0: Foundation** | | | |
| Async executor | #85 | ✅ DONE | |
| ML abstraction layer | #61 | ✅ DONE | |
| Rababa port (TS side) | #60 | ✅ DONE | |
| Secryst port (TS side) | #87 | ✅ DONE | |
| Unified transliterateAsync | #86 | ✅ DONE | |
| Unified MLModel interface | #13 | SPEC | 0.5 day |
| **P0: Training** | | | |
| Unified training repo | #10 | ✅ DONE | 1 day |
| Data pipeline (Arabic) | rababa/01 | SPEC | 2 days |
| Self-pretrain (Arabic) | rababa/02b | SPEC | 0.5 day (GPU) |
| Direct supervised fine-tune | rababa/03 | SPEC | 1 day (GPU) |
| ONNX export | rababa/04 | SPEC | 0.5 day |
| Evaluation suite | rababa/05 | SPEC | 1 day |
| Thai→IPA data + training | secryst/01-05 | SPEC | 1 week |
| **P1: Deploy** | | | |
| HuggingFace hosting | rababa/06 | SPEC | 1 day |
| Website /ml page | #95 | SPEC | 1 day |
| API endpoint for ML maps | #14 | SPEC | 0.5 day |
| Browser optimization | rababa/12 | SPEC | 1 day |
| **P1: Ruby integration** | | | |
| Ruby autoload compliance | rababa/11 | SPEC | 1 day |
| Ruby ML adapters | secryst/09 | SPEC | 1 day |
| **P2: Scale** | | | |
| Hebrew diacritization | rababa/07 | SPEC | 1 week |
| Future tasks (Khmer, JP, ZH) | secryst/07 | SPEC | TBD |
| CI/CD for training | rababa/09 | SPEC | 1 day |

## Key design decisions

1. **No quantization.** Train a better model instead. Quantizing a
   bad architecture (Tacotron) makes it smaller but not better.
2. **LLM teacher + distilled student.** Qwen3.5-4B has Arabic/Thai
   understanding from pretraining. Distill to 6 MB for browser.
3. **Unified framework.** Rababa and Secryst share everything except
   data and config. Adding a new task takes 5 minutes.
4. **OCP throughout.** New model kinds, new tasks, new backends =
   one new file each. Existing code never changes.
5. **Ruby autoload.** No `require_relative`. No `send`. No
   `instance_variable_set`. No `respond_to?`. Clean OOP.

## File index

### TODO.rababa/
- 00: Repository specification
- 01: Data pipeline (Tashkeela++)
- 02: Teacher model (Qwen3.5-4B)
- 03: Student model (distillation)
- 04: ONNX export + integration
- 05: Evaluation + benchmark
- 06: HuggingFace publishing
- 07: Hebrew diacritization
- 08: Secryst Thai→IPA (cross-ref to TODO.secryst/)
- 09: CI/CD
- 10: Unified training framework
- 11: Ruby autoload compliance
- 12: Browser inference optimization
- 13: Unified model interface (MLModel.transform)
- 14: Production deployment + monitoring

### TODO.secryst/
- 00: Repository specification (unified with rababa)
- 01: Thai→IPA data pipeline
- 02: Teacher model (Qwen3.5-4B for Thai)
- 03: Student model (shared architecture)
- 04: ONNX export + integration
- 05: Evaluation (PER instead of DER)
- 06: HuggingFace publishing
- 07: Future transliteration tasks
- 08: CI/CD (shared)
- 09: Ruby autoload compliance
