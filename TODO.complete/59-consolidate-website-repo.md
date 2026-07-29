# 59 — Consolidate website to single repo

**Status:** DONE

## Action
- Migrated v2 Astro site into the legacy `interscript/interscript.github.io` repo on branch `astro-migration`
- Opened PR [#119](https://github.com/interscript/interscript.github.io/pull/119) for review
- Archived the parallel `interscript/interscript.org-v2` repo

## Why
User directive: "we only have 1 website repo!"

## What was preserved
- All legacy code in git history (recoverable via `git checkout main -- ...`)
- Legacy content (blog .adoc, docs .adoc, map data) copied into `_legacy-content/`
- Legacy `posts/` and `docs/` AsciiDoc files now in `src/content/blog/` and `src/content/docs/` (active content collections)

## What was replaced
- `static.config.js` (react-static) → `astro.config.mjs`
- `src/components/*.tsx` (React) → `src/components/*.vue` (Vue islands)
- `src/pages/*.tsx` → `src/pages/*.astro`
- `bin/`, `walk.js`, `images.d.ts`, `interscript.d.ts`, `types/` removed (Astro equivalents)

## After merge
- Update DNS / GitHub Pages config if needed
- Verify `www.interscript.org` serves the new build
- Delete `_legacy-content/` once content port fully complete (TODOs 50-58 closed)

## Test plan
- [x] Build clean (18 pages)
- [x] All vitest tests pass
- [x] Sample blog posts render with full HTML body
- [x] Sample docs render with sidebar nav
- [ ] Preview deploy before merging to main
