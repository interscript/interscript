# 50-58 — Site feature port TODOs

Each is a discrete unit of work for reaching legacy site parity.

## 50 — 404 page
**Files:** `src/pages/404.astro`
**Scope:** S — static page, links home/docs/demo
**Inspiration:** `interscript.github.io/src/pages/404.tsx`

## 51 — Blog post detail pages
**Files:** `src/content/blog/config.ts`, `src/pages/blog/[slug].astro`
**Scope:** M — Astro content collection for `.adoc` files
**Steps:**
1. Define collection schema in `src/content/blog/config.ts`
2. Copy `.adoc` files from `interscript.github.io/posts/` into `src/content/blog/`
3. Add `@asciidoctor/starlight` or `astro-asciidoctor` integration
4. Render via `[slug].astro` dynamic route
5. Test that all 4 posts render

## 52 — Docs viewer with AsciiDoc rendering
**Files:** `src/content/docs/config.ts`, `src/pages/docs/[slug].astro`
**Scope:** M — port 6 `.adoc` docs
**Steps:**
1. Same content-collection pattern as TODO 51
2. Render AsciiDoc with sidebar nav (Section, SectionNav from legacy)
3. Cross-link to map format spec and editing guide
4. Test that all 6 docs render

## 53 — Featured-authority landing pages
**Files:** `src/pages/authorities/[slug].astro`
**Scope:** S — page per authority with systems list
**Data:** Static JSON of authorities × systems

## 54 — Systems catalog (full)
**Files:** `src/pages/systems.astro`, `src/components/SystemCatalog.vue`
**Scope:** L — searchable/filterable catalog of all 300+ maps
**Data:** Either:
- Bundle `maps/index.json` at build time (current Ruby rake output)
- Or fetch from `interscript-maps-ir` npm package (TODO 45)
**Features:**
- Search by system code
- Filter by authority, source script, destination script
- Click to open in MapExplorer

## 55 — Rababa demo island
**Files:** `src/components/RababaDemo.vue`
**Scope:** M — calls a backend (or wasm) to run rababa diacritization
**Blocker:** Rababa requires ONNX model; either:
- Backend API endpoint at `interscript.org/api/rababa`
- Or WASM build of rababa-ruby (research)

## 56 — Auto-detect island
**Files:** `src/components/AutoDetect.vue`
**Port from:** `interscript.github.io/src/auto_detect.ts`, `detect_lang.js`, `detect_script.js`
**Scope:** M — given input + output, suggest best-matching system
**Uses:** `interscript-ts` `detect()` API

## 57 — Quick transliteration widget
**Files:** `src/components/QuickBox.vue`
**Scope:** S — compact inline transliteration (for blog posts, docs)

## 58 — Search overlay
**Files:** `src/components/SearchOverlay.vue`
**Scope:** M — pagefind or lunr integration for site-wide search
**Steps:**
1. `npm install astro-pagefind`
2. Add integration in `astro.config.mjs`
3. Wire `SearchButton.vue` to open overlay
