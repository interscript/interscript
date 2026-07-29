# 49 — Legacy site audit and content port backlog

**Status:** ONGOING — audit complete, content port in progress

## Legacy site (`interscript.github.io`) audit

### Pages (10 — `src/pages/*.tsx`)
| Page | Ported to v2? | Notes |
|------|---------------|-------|
| `index.tsx` (home) | ✅ | Reimagined: hero, stats, features, code samples |
| `404.tsx` | ❌ TODO 50 | Add `404.astro` with site nav |
| `about.tsx` | ✅ | Mission/history/team |
| `authorities.tsx` | ✅ | Table of 8 authorities |
| `blog.tsx` (index) | ✅ | 4 post index |
| `blogPost.tsx` (detail) | ❌ TODO 51 | Need Astro content collection |
| `demo.tsx` | ✅ | Live transliteration via interscript-ts |
| `docs.tsx` (index) | ✅ | Basic; needs full AsciiDoc rendering (TODO 52) |
| `docsView.tsx` (detail) | ❌ TODO 52 | Render individual `.adoc` files |
| `featured-authorities/*.tsx` | ❌ TODO 53 | Curated authority landing pages |
| `systems.tsx` (full catalog) | ❌ TODO 54 | Searchable catalog (needs map index JSON) |

### Components (28 — `src/components/*.tsx`)
| Component | Ported? | Replacement |
|-----------|---------|-------------|
| `LiveDemo.tsx` | ✅ | `MapExplorer.vue` (Vue island) |
| `Rababa.tsx` | ❌ | Rababa demo island (TODO 55) |
| `SystemSelector.tsx` / `SystemSelector2.tsx` | ✅ | Built into `MapExplorer.vue` |
| `Statistics.tsx` | ✅ | Stats grid on home |
| `DetectSystem.tsx` | ❌ | Auto-detection island (TODO 56) |
| `FilterBar.tsx` | ❌ | Filter UI for systems page (TODO 54) |
| `Tiles.tsx` | ❌ | Tile-grid layout helper (TODO 54) |
| `QuickBox.tsx` | ❌ | Quick transliteration widget (TODO 57) |
| `Section.tsx`, `SectionNav.tsx`, `SectionNavItem.tsx` | ❌ | Doc-section nav (TODO 52) |
| `HeaderMenu.tsx`, `MainNav.tsx`, `TopNav.tsx`, `HeaderHashlinksMenu.tsx` | ✅ | Consolidated in `Base.astro` |
| `SearchButton.tsx` | ❌ | Search overlay (TODO 58) |
| `EasyAccess.tsx` | ❌ | Accessibility widget |
| `Example.tsx`, `Usage.tsx`, `ReadmeSectionPage.tsx` | ❌ | Doc feature components (TODO 52) |
| `InputField.tsx`, `Form.tsx`, `Select.tsx` | ❌ | Form primitives |
| `Lang.tsx`, `isoLang.ts`, `WritingSystem.tsx` | ❌ | Language/script pickers |
| `AdocStyleWrapper.tsx`, `GithubHightlightTheme.tsx` | ❌ | AsciiDoc rendering (TODO 52) |

### Blog posts (4 — `.adoc`)
- `2021-06-26-webassembly-and-advanced-regular-expressions-with-opal.adoc`
- `2021-08-03-diacritization-in-arabic-with-deep-learning.adoc`
- `2021-10-03-extending-rababa-for-hebrew-diacriticization.adoc`
- `2022-04-04-transliteration-learned-from-transformers-and-graphs.adoc`

Port: copy `.adoc` into `src/content/blog/`, configure Astro content collection + `@asciidoctor/starlight` or similar (TODO 51).

### Docs sections (6 — `.adoc`)
- `Integration_with_Ruby_Applications.adoc`
- `Interscript_Map_Format.adoc`
- `Maintainers.adoc`
- `Map_Editing_Guide.adoc`
- `Usage_with_Rababa.adoc`
- `Usage_with_Secryst.adoc`

Port: `src/content/docs/` collection (TODO 52).

### Other source (`src/`)
- `auto_detect.ts` — auto-detect language/script → suggest system (TODO 56)
- `detect_lang.js`, `detect_script.js`, `priority.js` — detection helpers
- `meta.ts` — site metadata
- `routes.js`, `App.tsx`, `index.tsx`, `scs.ts` — react-static internals (replaced by Astro)

### Static assets
- `posts/` — blog `.adoc` source
- `docs/` — docs `.adoc` source
- `map/` — bundled maps data
- `artifacts/` — build output (regenerated)
- `images.d.ts`, `interscript.d.ts` — type declarations

## v2 site status

### Pages built (7)
- `/` (home)
- `/demo` (live transliteration)
- `/maps` (catalogue)
- `/authorities` (table)
- `/blog` (post index)
- `/about`
- `/docs` (quick start; full docs TODO 52)

### Test coverage
- 15 vitest tests passing
- Build + check + test in CI

### Deferred as separate TODOs
- TODO 50: 404 page
- TODO 51: Blog post detail (Astro content collection)
- TODO 52: Docs viewer with AsciiDoc rendering
- TODO 53: Featured-authority landing pages
- TODO 54: Systems catalog with search/filter
- TODO 55: Rababa demo island
- TODO 56: Auto-detect island
- TODO 57: Quick transliteration widget
- TODO 58: Search overlay

## Effort
L (multi-day for full feature parity)
