# rababa-v2: 07 — Hebrew diacritization (same pipeline, different data)

**Status:** SPECIFICATION
**Priority:** P2

## Goal

Apply the same training pipeline to Hebrew diacritization. Hebrew
faces the same problem as Arabic: text is normally written without
vowel marks (nikud). The rababa Ruby gem already has a Hebrew path
(`python/hebrew/`), but it uses the same legacy Tacotron architecture.

## Training data

- **Hebrew Wiktionary**: nikud-annotated entries
- **Sefaria**: open Torah/Tanakh texts with full nikud
- **Hebrew National Corpus**: modern Hebrew with nikud
- Total: ~10-20M words (smaller than Arabic; may need more synthetic
  augmentation)

## Architecture

Same student architecture as Arabic (00-05). Different training data.
The fine-tuned teacher handles Hebrew + Arabic in one model if the
base LLM supports both (Qwen2.5 and Gemma-2 both do).

## Map integration

```ruby
# var-heb-Hebr-Hebr-rababa.imp (new map)
stage {
  rababa config: "hebrew", model: "llm"
}
```

## Acceptance

- [ ] Hebrew training data pipeline built
- [ ] Student model trained on Hebrew
- [ ] DER < 5% on Hebrew test split (higher tolerance than Arabic
  because of smaller training corpus)
- [ ] ONNX exported and loadable in interscript-ts
