# 76 — Streaming API responses (SSE / chunked)

**Status:** TODO
**Priority:** P2

## Problem

`POST /api/transliterate/batch` returns all results at once. For a
1000-item batch that's a long-blocking request. Better: stream results
as they complete via Server-Sent Events.

## Fix

`POST /api/transliterate/stream` returns SSE:
```
event: result
data: {"index":0,"output":"Anton"}

event: result
data: {"index":1,"output":"Kyiv"}

event: done
data: {"count":1000,"durationMs":4321}
```

Client gets results incrementally — better UX for batch UIs, partial
results on disconnect, naturally backpressure-friendly.

## Acceptance

- [ ] SSE endpoint at `/api/transliterate/stream`
- [ ] Documented in OpenAPI spec
- [ ] Test client in the API playground
- [ ] Specs verify event format + ordering
