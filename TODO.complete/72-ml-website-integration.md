# 72 — Wire ML into website (Rababa live demo)

**Status:** TODO
**Priority:** P1 (depends on #62)

## Goal

Once Rababa runs in interscript-ts, expose it on the website:
- New `/ml` page explaining ML-powered maps
- Live demo of `var-ara-Arab-Arab-rababa`
- Status indicator showing model load progress
- Privacy note: model is downloaded once, cached, runs in worker

## Layout

```
/ml (overview)
  - what ML maps are
  - how they differ from rule maps
  - link to model card (HuggingFace)
  - live demo (Arabic input → diacritized output)

/ml/rababa (deep page)
  - architecture explanation
  - model card
  - interactive demo with examples
  - link to training data source

/ml/secryst (placeholder until Thai-IPA model is converted)
  - explanation
  - status: "ONNX conversion pending — see #63"
```

## Performance considerations

- 60 MB model is too large to load eagerly
- Lazy-load via Web Worker when user navigates to `/ml` or invokes
  a rababa map
- Show progress bar during download
- Cache via Service Worker so subsequent visits are instant

## Acceptance

- [ ] `/ml` page renders with live demo
- [ ] Model lazy-loads only on demand
- [ ] Service Worker caches the model file
- [ ] Privacy policy clearly states no input leaves the browser
