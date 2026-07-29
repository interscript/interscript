# 30 — `interscript.org-v2` Astro 7 scaffold

**Status:** DONE — initial scaffold published

## What was created
New repo: https://github.com/interscript/interscript.org-v2

### Stack
| Tool | Version |
|------|---------|
| Astro | 7.1.5 |
| Vite | 8.1.5 (Astro default) |
| Tailwind | 4.3.3 (CSS-first config via `@theme`) |
| Vue | 3.5.40 (islands via `@astrojs/vue` 7.0.1) |
| TypeScript | 5.6 |

### Pages
- `/` — home (hero + feature cards)
- `/maps` — map explorer using `MapExplorer.vue` Vue island
- `/docs` — getting started (Ruby + TS snippets)

### Vue island
`src/components/MapExplorer.vue` — system selector + input + output panel. Currently uses stub output (will wire to `interscript-ts` once published).

### Styling
Tailwind 4 CSS-first config:
- `@theme` tokens for colors (`--color-ink`, `--color-paper`, `--color-accent`)
- `@import "tailwindcss"` in `src/styles/global.css`
- Vite plugin `@tailwindcss/vite` instead of PostCSS

### Layout
`src/layouts/Base.astro` — HTML shell with nav (Maps, Docs, GitHub) + footer. All pages use this.

### CI
- `deploy.yml` — build → upload-pages-artifact → deploy-pages on main
- Node 22 in CI
- `astro check` for type safety before build

## Verification
- `npm run check` ✓ (0 errors)
- `npm run build` ✓ (3 pages built in 24ms)

## What's not in this scaffold
- Porting content from legacy react-static site
- Real interscript-ts integration (stubbed)
- Search, tree menu, blog posts
- AsciiDoc content pipeline
- Lighthouse audit pass

## Cutover plan
1. interscript.org-v2 reaches feature parity with interscript.github.io
2. Update GitHub pages config to serve from interscript.org-v2
3. Archive interscript.github.io
4. Rename interscript.org-v2 → interscript.github.io (or just update DNS)
