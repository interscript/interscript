# rababa-v2: 14 — Production deployment + monitoring

**Status:** SPECIFICATION
**Priority:** P1

## Goal

ML models running reliably in production: API endpoint serves ML maps,
monitoring catches regressions, CI prevents bad models from deploying.

## API integration

The existing `/api/transliterate` endpoint already supports async:
```typescript
export const prerender = false
// POST /api/transliterate uses transliterateAsync internally
```

When a user calls `/api/transliterate?system=var-ara-Arab-Arab-rababa`:
1. Server loads the rababa student model (cached after first call)
2. Runs inference via `onnxruntime-node`
3. Returns diacritized output

Model is loaded once per server process (singleton). Cached in memory.

## Cold start

First request after server start: ~2-5 seconds (model load + ONNX session init).
Subsequent requests: ~50-200ms per word.

Mitigation:
- Warm-up request on server start (loads model immediately)
- Health check endpoint reports model status

## Monitoring

### Model health
- Track DER on a fixed held-out set every hour
- Alert if DER > 5% (student regressed or model file corrupted)

### Latency
- p50, p95, p99 inference time per request
- Alert if p95 > 500ms

### Error rate
- Percentage of requests returning SystemConversionError
- Alert if > 1% in a 5-minute window

## CDN strategy

Static site + maps: Cloudflare/Vercel CDN (already configured).
ML models: HuggingFace CDN (already configured in provisioner).
ONNX runtime: bundled via npm (onnxruntime-node for server, onnxruntime-web for browser).

## Acceptance

- [ ] API endpoint serves ML maps without timeout
- [ ] Warm-up on server start
- [ ] Health check reports ML model status
- [ ] DER monitoring with alerting
- [ ] Latency dashboard on /status page
