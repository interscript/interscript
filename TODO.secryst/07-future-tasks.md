# secryst-v2: 07 — Future transliteration tasks (unified pipeline)

**Status:** SPECIFICATION
**Priority:** P2

## Goal

The unified framework (TODO.rababa/10) makes adding new secryst tasks
trivial: one config + one data module per task. This file documents
candidates.

## Candidate tasks

### Khmer → IPA
- Parallel data: Khmer diacritics repo (`interscript/khmer-diacritics`)
- Already has a secryst model in Ruby (Khmer script)
- Would benefit from LLM pretraining (Khmer is in Qwen's training data)

### Amharic → Latin (morphological)
- Some Amharic transliteration decisions depend on morphology
  (verb root vs. noun form) — rules can't always disambiguate
- Training data: parallel Amharic-English dictionaries + ALA-LC tables
- Currently handled by rules; ML could improve accuracy on edge cases

### Japanese → Romaji (context-dependent)
- Multiple readings for the same kanji (人 = jin, nin, hito, ...)
- Context determines the reading — a task LLMs excel at
- Training data: furigana-annotated corpora (BCCWJ, Aozora Bunko)
- Would be a new map: `var-jpn-Hrkt-Latn-llm`

### Chinese → Pinyin (context-dependent polyphones)
- Some characters have multiple readings (了 = le, liǎo)
- Context determines pronunciation
- LLMs already solve this in production (translation APIs)
- Would replace/augment the existing Hanyu Pinyin maps

## How to add a new task (5 minutes)

```bash
# 1. Create the task directory
mkdir -p src/tasks/secryst_<source>_<target>/

# 2. Write the config
cat > src/tasks/secryst_<source>_<target>/config.yaml << EOF
model: Qwen/Qwen3.5-4B
method: lora
data:
  train_split: data/processed/<source>_<target>_train.jsonl
  val_split: data/processed/<source>_<target>_val.jsonl
EOF

# 3. Write the data module
cat > src/tasks/secryst_<source>_<target>/data.py << EOF
from src.framework.data import DataModule

class MyData(DataModule):
    def prepare_data(self):
        # Download + clean + augment
        ...
EOF

# 4. Train
python -m src.cli train --task secryst_<source>_<target>
```

Zero edits to framework code. **OCP**.

## Acceptance

- [ ] At least one additional task (Khmer→IPA or Japanese→Romaji) configured
- [ ] Task runs through the unified pipeline
- [ ] Documentation shows the 5-minute process
