# 43 — interscript-ts v0.1.0 publish

**Status:** READY — tag triggers publish workflow

## Why
The interscript-ts package is functionally complete for v0.1.0:
- 94 tests passing (94%)
- Coverage: 85% statements, 75% branches, 82% functions, 87% lines
- 3/5 sample maps achieve byte-exact Ruby parity
- Real Ruby JsonIR compiler (PR interscript/interscript-ruby#757)
- CI green: build + test + lint + coverage
- Release workflow with npm provenance

## Action
```bash
cd /Users/mulgogi/src/interscript/interscript-ts
git tag v0.1.0
git push origin v0.1.0
```

This triggers `.github/workflows/release.yml` which:
1. Builds the package
2. Runs `npm publish --provenance --access public`
3. Publishes to npmjs.com as `interscript-ts@0.1.0`

## Pre-publish checklist
- [ ] Merge Ruby JsonIR PR (interscript/interscript-ruby#757) so published IR is reproducible from public Ruby gem
- [ ] Configure `NPM_TOKEN` secret in repo settings (with publish permission)
- [ ] Verify package name `interscript-ts` is not taken on npmjs.com (need to check)
- [ ] Add `repository.url` confirms `interscript/interscript-ts`
- [ ] README has install + usage examples
- [ ] LICENSE present (BSD-2-Clause)

## Post-publish
- [ ] Update interscript.org-v2 to depend on `interscript-ts` (TODO 37)
- [ ] Announce availability
- [ ] Tag v0.2.0 once parallel-rule semantics land (TODO 42)

## Risk
- First publish; npm account must exist and have 2FA
- Provenance requires public repo (✓) and GitHub Actions attestation
