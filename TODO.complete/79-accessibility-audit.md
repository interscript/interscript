# 79 — Accessibility audit (WCAG 2.2 AA)

**Status:** TODO
**Priority:** P1

## Problem

The site has been built quickly with design first, accessibility
second. Need to verify against WCAG 2.2 AA.

## Areas to audit

- Color contrast (especially the brand teal on paper)
- Keyboard navigation (skip links, focus management)
- Screen reader (ARIA, semantic HTML)
- Reduced motion (already partially handled)
- Form labels and error states
- iframe embed (must have title attribute)

## Acceptance

- [ ] axe-core run in CI; zero critical violations
- [ ] Lighthouse a11y ≥ 95 on every page type
- [ ] Keyboard-only user test passes for: catalogue, compare, batch,
  detect, MARC tool, subtitles, API playground
- [ ] Screen reader test on key flows
