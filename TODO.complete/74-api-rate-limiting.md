# 74 — API rate limiting + abuse protection

**Status:** TODO
**Priority:** P1

## Problem

Public REST API at `/api/*` currently has no rate limits. One bad actor
could DoS the service or burn through the deployment budget.

## Fix

Implement token-bucket rate limiting at the API route layer:

- Per-IP: 100 requests/minute, 1000/hour
- Burst allowance: 10 requests in 1 second
- Return `429 Too Many Requests` with `Retry-After` header
- `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` headers

Implementation:
- In-memory token bucket per IP (resets on server restart — acceptable)
- For multi-instance deploys: shared Redis bucket (deferred)

## Tier strategy

- Anonymous: limits above
- API key (future): higher limits, usage tracking
- Self-hosted: no limits — your node, your rules

## Acceptance

- [ ] Rate limit middleware on `/api/*`
- [ ] 429 + Retry-After on exceeded
- [ ] Headers on every response
- [ ] Specs: verify limits, burst, reset
- [ ] Documented on `/api-docs`
