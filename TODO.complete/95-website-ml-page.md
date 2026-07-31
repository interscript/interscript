# 95 — Website /ml page with live demo

**Status:** P1
**Depends on:** #89, #93

## Goal

Add `/ml` to the website — explains ML-powered maps, shows the Rababa
diacritizer running live in the browser. This is the public face of
ML integration.

## Layout

```
/ml (overview)
  Hero: "Some maps need machine learning"
  - What ML maps are vs rule-based
  - Privacy: models run in browser, text never uploaded
  - Architecture diagram (encoder → ONNX → reconciler)

  Live demo:
  - Input field: paste Arabic text
  - Output: diacritized text
  - Progress bar during model load (60MB → cached after first)
  - System: var-ara-Arab-Arab-rababa

  Comparison:
  - Show input → diacritized → romanized (the full ML + rule pipeline)
  - Example: قطر → قِطْرَ → Qatar (via bgnpcgn-ara-Arab-Latn-1956)

  Model card link:
  - HuggingFace badge
  - Architecture explanation
  - Training data source
```

## Performance

- Model loads lazily only when user visits /ml
- Service Worker caches the ONNX file
- Web Worker for inference (reuse existing infrastructure)
- Progress indicator during 60MB download

## Acceptance

- [ ] `/ml` page renders
- [ ] Live demo works (input → output)
- [ ] Model progress bar visible during first load
- [ ] Subsequent visits instant (cached)
- [ ] Privacy notice prominent
