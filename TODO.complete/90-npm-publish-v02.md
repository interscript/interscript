# 90 — npm publish interscript-ts v0.2.0

**Status:** P1
**Depends on:** #85–#89

## Release checklist

### Package
- [ ] Bump version to 0.2.0
- [ ] Update README with ML section
- [ ] Update CHANGELOG
- [ ] Add `peerDependencies` for onnxruntime-node/web
- [ ] Verify `npm pack` output is clean
- [ ] Verify no node:fs leaks in browser bundle

### API
- [ ] `transliterate` (sync) — all non-ML maps
- [ ] `transliterateAsync` — all maps including ML
- [ ] `httpStrategy` — fetch from CDN
- [ ] `bundledStrategy` — in-memory
- [ ] `filesystemStrategy` — Node only
- [ ] `loadModel` + `registerModel` — ML module
- [ ] CLI subcommands: transliterate, batch, list, detect

### Distribution
- [ ] Published to npm
- [ ] Available on jsDelivr CDN
- [ ] Available on esm.sh
- [ ] GitHub release with release notes

### Promotion
- [ ] Tweet/blog post
- [ ] Update interscript.org install page
- [ ] Update Ruby gem docs cross-referencing TS package
