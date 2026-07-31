# 91 — WebGPU inference backend

**Status:** P2
**Depends on:** #89

## Why

WebGPU gives 5-10× speedup over WASM SIMD for ONNX models:
- Rababa: 500ms → 50ms per name in browser
- Batch: 1000 names in ~5 seconds instead of 50

onnxruntime-web supports WebGPU execution provider natively.

## Approach

In `src/ml/session/onnx-web.ts`:
```typescript
// Try WebGPU first, fall back to WASM
try {
  session = await ort.InferenceSession.create(data, {
    executionProviders: ["webgpu", "wasm"],
  })
} catch {
  // WebGPU not available, use WASM only
  session = await ort.InferenceSession.create(data, {
    executionProviders: ["wasm"],
  })
}
```

## Acceptance

- [ ] WebGPU detected and used when available
- [ ] Falls back to WASM seamlessly
- [ ] 5×+ speedup on Chrome/Edge with GPU
- [ ] No regression on Firefox (no WebGPU yet)
