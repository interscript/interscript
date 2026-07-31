# 80 — i18n: serve the site in source-script native languages

**Status:** TODO
**Priority:** P3

## Problem

The site is English-only. Given the subject matter (every script under
the sun), having localized landing pages for major source-language
communities would massively expand reach.

## Approach

Astro i18n routes:
- `/uk/` — Ukrainian
- `/ar/` — Arabic
- `/zh/` — Chinese
- `/hi/` — Hindi
- `/ja/` — Japanese
- `/ko/` — Korean
- `/th/` — Thai

Each landing page can be romanized through Interscript itself — meta.

## Acceptance

- [ ] Astro i18n config wired
- [ ] At least 3 language landing pages (UK, AR, ZH)
- [ ] Language switcher in nav
- [ ] hreflang tags correct
- [ ] Specs verify each locale renders
