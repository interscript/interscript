# 35 — interscript-ts npm publish + provenance

**Status:** READY — workflow configured, awaiting first tag

## What's configured
`.github/workflows/release.yml` in `interscript-ts`:
- Triggers on `v*` tag push
- Node 22 + npm ci + build + test
- `npm publish --provenance --access public`
- Uses `INTERSCRIPT_NPM_TOKEN` secret
- `id-token: write` permission (required for provenance)

## Awaiting
- npm package name confirmation: `interscript-ts` (current)
  - Alternative: rename to take over `interscript` once interscript-js is deprecated
- npm access (publish rights to the package name)
- Tag push: `git tag v0.1.0 && git push --tags`

## Post-publish
- Verify at https://www.npmjs.com/package/interscript-ts
- Check provenance badge appears
- Add npm version badge to README

## Related
TODO 32 (deprecated interscript-js when interscript-ts reaches v1.0)
