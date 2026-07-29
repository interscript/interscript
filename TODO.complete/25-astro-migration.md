# 25 — Astro migration for `interscript.org` (Phase G2)

**Status:** DEFERRED — multi-day effort

## Why
- Current site uses `react-static 7` (project abandoned)
- React 16, TypeScript 3.5, axios 0.19 (CVEs) all need to go
- Astro is the natural fit: content-heavy static site + selective React islands

## Scope (from main plan)
1. Scaffold Astro project (`npm create astro@latest . -- --template minimal --typescript strict`)
2. Port layout + nav + footer
3. Port home page
4. Port static doc pages (AsciiDoc → HTML already produced)
5. Port map interactive UI as React island
6. Port search/tree menus
7. Remove: react-static plugins, axios, @reach/router
8. Update deps: React 18+, TypeScript 5+, Node engines >= 20
9. CI Node 22, deploy from Astro `dist/`

## Acceptance criteria
- All current pages render correctly against https://www.interscript.org
- Lighthouse score ≥ 90 across all categories
- CI green on Node 22
- Bundle size reduced vs react-static baseline

## Estimated effort
5-10 days depending on map tool complexity.

## Notes
- Phase G1 (CI/GHA bump) already done — Node 18 baseline while react-static remains
- This PR will bump Node to 22 as part of the framework swap
