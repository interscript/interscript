# 05 — OIDC trusted publishing (RubyGems + npm)

**Status:** DEFERRED — requires dashboard actions outside the API

## Why
Current release workflows use long-lived secrets (`INTERSCRIPT_RUBYGEMS_API_KEY`, `INTERSCRIPT_NPM_TOKEN`). OIDC trusted publishing rotates credentials automatically and cannot be exfiltrated from CI secrets.

## What's done
- Release workflows are structured to be ready: build → push via short-lived credentials
- Permissions block is explicit on each

## What's blocking
1. **RubyGems.org**: opt in at https://rubygems.org/profile/<you>/oidc (or follow RubyGems trusted-publisher beta process). Then:
   - Replace `printf -- "---\n:rubygems_api_key: %s\n" ...` block in release.yml with `rubygems/rubygems-oidc` action (or equivalent)
   - Remove `INTERSCRIPT_RUBYGEMS_API_KEY` secret
2. **npmjs.com**: enable provenance for the package at https://www.npmjs.com/package/interscript/access. Then:
   - Add `id-token: write` permission to release.yml
   - Add `npm publish --provenance --access public`
   - Remove `INTERSCRIPT_NPM_TOKEN`

## Effort
S once dashboard access is confirmed. Needs a live release to verify end-to-end.

## Affects
- `maps/.github/workflows/release.yml`
- `interscript-ruby/.github/workflows/release.yml`
- `interscript-js/.github/workflows/release.yml`
- `rababa/.github/workflows/release.yml`
