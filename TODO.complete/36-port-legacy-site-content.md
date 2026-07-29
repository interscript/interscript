# 36 — Port content from legacy site to v2

**Status:** TODO

## Why
`interscript.org-v2` has home, maps, docs scaffolds. The legacy `interscript.github.io` has years of accumulated content: blog posts, AsciiDoc docs, sample pages, full map browser with tree menu.

## Scope

### Content to port
- All `posts/` (AsciiDoc blog posts)
- All `docs/` (AsciiDoc documentation)
- Map browser with tree menu (Vue island)
- Search functionality
- Footer with project info
- All metadata pages (authority, system code lists)

### AsciiDoc pipeline
Legacy site uses `asciidoctor.js` to render AsciiDoc at build time. Port:
- `yarn adoc make` equivalent → Astro integration
- Custom remark/rehype plugin or shell out to asciidoctor

### Map browser features
- Tree menu of all map system codes (~300 items)
- Search by authority / script pair / language
- Live transliteration (currently stubbed in MapExplorer.vue)

## Acceptance criteria
- All URLs from legacy site work on v2 (redirect or direct)
- Lighthouse ≥ 90 across categories
- Bundle size < 200KB gzipped for home page

## Effort
L (1-2 weeks of focused work)
