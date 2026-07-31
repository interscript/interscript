# 69 — Generate /api-docs from OpenAPI spec

**Status:** TODO
**Priority:** P2

## Problem

`/api-docs` is hand-written HTML. The OpenAPI spec at `/openapi.json`
is hand-written TypeScript. They will drift.

## Fix

`/api-docs` should be generated from `/openapi.json` at build time:

```
openapi.json → @astrojs integration or pre-build script → /api-docs HTML
```

Options:
- `swagger-ui-react` (existing, polished, +500KB JS)
- `rapidoc` (web component, lighter)
- Hand-rolled Astro template iterating the spec (what we have, just
  driven by the spec instead of by hand)

Recommended: hand-rolled, kept lean. Pulls `info`, `paths`, `schemas`
from the JSON; renders the same template structure we already have.

## Acceptance

- [ ] `/api-docs` reads `/openapi.json` at build time
- [ ] Adding a new endpoint to `openapi.json.ts` automatically renders
  docs for it
- [ ] Specs verify the docs cover every path in the spec
