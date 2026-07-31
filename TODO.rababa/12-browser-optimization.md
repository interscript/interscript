# rababa-v2: 12 — Browser inference optimization

**Status:** SPECIFICATION
**Priority:** P1

## Goal

Make ML inference fast enough in the browser that it's indistinguishable
from rule-based transliteration.

## Stack

```
User types Arabic text
  → Web Worker (off main thread)
    → onnxruntime-web
      → WebGPU (if available) or WASM SIMD (fallback)
        → Student model (~6 MB, cached via Service Worker)
          → Diacritized output
```

## Optimization layers

### 1. WebGPU execution provider (5-10× over WASM)
```typescript
const session = await ort.InferenceSession.create(modelData, {
  executionProviders: ["webgpu", "wasm"],
})
```
Auto-detected. Chrome/Edge/Safari 17+ support WebGPU. Falls back
seamlessly.

### 2. WASM SIMD + multi-threading
```typescript
ort.env.wasm.simd = true
ort.env.wasm.numThreads = navigator.hardwareConcurrency || 4
```
Default for browsers without WebGPU (Firefox). SIMD gives ~2× over
scalar WASM.

### 3. Model caching
- First visit: download 6 MB ONNX via fetch()
- Service Worker caches the file permanently
- IndexedDB for the ORT session itself (avoids re-creating)
- Subsequent visits: instant load from cache

### 4. Speculative decoding (advanced)
For the student model: predict 2 tokens at a time, verify the second
token with the teacher. If correct, skip ahead. ~1.5× speedup on
long inputs.

### 5. Quantization-free small model
The student is already 6 MB — no quantization needed. The whole point
of distillation is to get the right size WITHOUT compression that
degrades quality.

## Acceptance

- [ ] WebGPU path implemented with fallback
- [ ] Service Worker caches ONNX model
- [ ] Inference: <20ms/word (WebGPU), <50ms/word (WASM SIMD)
- [ ] No UI freeze during inference (Web Worker)
- [ ] First-load progress indicator
