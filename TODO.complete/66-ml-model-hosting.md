# 66 — ML model hosting + CDN

**Status:** TODO
**Priority:** P1 (blocks browser-side ML)

## Problem

ML models are too large to bundle in `interscript-ts` (60 MB ONNX would
make the npm package unusable). Need a hosting strategy.

## Options

### A. HuggingFace Hub

- Free for open-source models
- Direct ONNX download URLs
- CDN-backed globally
- Already used by `@xenova/transformers` ecosystem
- Models versioned via git-LFS

**Recommended.** Mirrors the open-source ethos; integrates with the
broader ML community.

### B. jsDelivr CDN

- Mirror from GitHub releases
- Polished for npm/JS use
- Global CDN
- Free for OSS

### C. Self-host on interscript.org

- Already have the website
- But: bandwidth costs; not designed for large binary assets

## Provisioning pattern

```
user calls rababa(config: "200")
  → ML function calls ModelProvisioner.ensure("rababa-arabic-200")
  → Provisioner checks cache (in-memory → localStorage → IndexedDB)
  → If miss: fetch from HuggingFace CDN
  → Compute SHA256, verify against manifest
  → Open via InferenceSession.create()
  → Cache for next call
```

## Manifest

`models-manifest.json` lists every published model with:
- name, kind (rababa/secryst/byt5/...)
- size, sha256
- license, source URL
- input/output schema

This is downloaded by the runtime on first ML call. Small (~5KB).

## Acceptance

- [ ] HuggingFace repo created: `interscript/rababa-arabic-max-len-200`
- [ ] Model uploaded with metadata
- [ ] `httpStrategy` extended to verify SHA256 against manifest
- [ ] IndexedDB cache layer for browser (60 MB doesn't fit in localStorage)
- [ ] Models-page section on interscript.org documenting the catalog
