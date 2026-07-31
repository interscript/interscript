# 84 — Telemetry / privacy-preserving analytics

**Status:** TODO
**Priority:** P3

## Problem

No visibility into which maps are used, where errors happen, what the
audience looks like. Without data, prioritization is guessing.

## Approach

Privacy-first analytics:
- Self-hosted Plausible or Umami
- Aggregate request counts only; never log input content
- Explicit "no PII" promise on privacy page
- Public stats dashboard at `/stats`

## What to track

- API endpoint hit counts (transliterate / systems / detect / batch)
- Most-requested systems (top 20)
- Error rate by system
- Geographic distribution (country-level only)
- Client type (curl / browser / interscript-ts library)

## Acceptance

- [ ] Analytics tool chosen and deployed
- [ ] Privacy policy updated
- [ ] Public dashboard
- [ ] No raw input logging, audited
