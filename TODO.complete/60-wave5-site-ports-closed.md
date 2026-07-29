# Updates to TODOs 50, 51, 52, 57 — closed by Wave 5

| TODO | Original status | New status | Closed by |
|------|-----------------|------------|-----------|
| [50](50-58-site-feature-ports.md) (404 page) | DEFERRED | DONE | `src/pages/404.astro` in astro-migration |
| [51](50-58-site-feature-ports.md) (blog detail) | DEFERRED | DONE | `src/pages/blog/[slug].astro` + AsciiDoc loader |
| [52](50-58-site-feature-ports.md) (docs viewer) | DEFERRED | DONE | `src/pages/docs/[slug].astro` + sidebar nav |
| [57](50-58-site-feature-ports.md) (quick widget) | DEFERRED | DONE | `src/components/QuickBox.vue` |

## Implementation summary

### 404 page
- `src/pages/404.astro` with hero "404", nav suggestions, GitHub issues link

### Blog detail (TODO 51)
- `src/content/blog/` Astro content collection
- `src/content/loaders/asciidoc.ts` — pure function `renderAsciiDocDir(dir)`
  parses header manually + converts body via `@asciidoctor/core`
- `src/pages/blog/[slug].astro` uses `getStaticPaths()` from the loader
- Renders AsciiDoc HTML body inline with `set:html`
- "Edit on GitHub" link per post

### Docs viewer (TODO 52)
- `src/content/docs/` collection (6 docs)
- `src/pages/docs/[slug].astro` with sidebar nav (active-link highlighting)
- Same AsciiDoc loader as blog (DRY)
- Updated `/docs` index page with runtime tiles + docs list

### Quick transliteration widget (TODO 57)
- `src/components/QuickBox.vue`
- Same dynamic-load pattern as MapExplorer (DRY)
- `compact` prop for inline use in blog/docs
- Curated 5-system selector

## Build
Site now produces 18 pages (was 8) with zero client JS for content.
