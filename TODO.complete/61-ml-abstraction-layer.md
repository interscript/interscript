# 61 — ML abstraction layer (interscript-ts)

**Status:** IN PROGRESS
**Priority:** P0 (foundation for #62–#66)

## Problem

Today, `rababa` and `secryst` are stubs in `stdlib.ts` that raise. They need:
- ONNX runtime integration (Node + browser)
- A model abstraction so adding new model kinds (ByT5, Mamba) doesn't require touching existing code
- Backend abstraction so the same code runs in Node (CLI/API) and browser (worker)

## Design (OCP/MECE/DRY)

```
src/ml/
├── index.ts              # public API surface
├── types.ts              # ModelKind, InferenceSession, ModelInput, ModelOutput
├── registry.ts           # ModelRegistry — register new kinds, never edit
├── session/
│   ├── index.ts          # InferenceSession interface
│   ├── onnx-node.ts      # Node backend via onnxruntime-node
│   ├── onnx-web.ts       # Browser backend via onnxruntime-web
│   └── factory.ts        # auto-detect env, return right session
├── provision/
│   └── index.ts          # ModelProvisioner: download + cache (uses httpStrategy infra)
├── vocab.ts              # YAML/JSON vocab loading + tokenization helpers
└── models/
    ├── rababa/           # registered as 'rababa'
    └── secryst/          # registered as 'secryst'
```

**OCP**: a new model kind (e.g. ByT5 Arabic) = new file in `src/ml/models/byt5/`. Zero edits elsewhere.
**MECE**: InferenceSession knows nothing about Arabic. RababaModel knows nothing about Node vs Web.
**DRY**: argmax, softmax, vocab tokenization, autoregressive decode are all shared utilities.

## Acceptance

- [ ] `import { createSession } from "interscript-ts/ml"` returns Node or Web backend based on env
- [ ] `registerModel("rababa", RababaFactory)` adds a new model kind
- [ ] Session auto-downloads + caches models (uses httpStrategy for cache plumbing)
- [ ] All specs pass
