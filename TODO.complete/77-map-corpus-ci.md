# 77 — Map corpus CI improvements

**Status:** TODO
**Priority:** P1

## Problem

When a contributor opens a PR adding a new map:
- Ruby specs run (good)
- IR regeneration runs (good)
- But: no automated check that the IR parses cleanly in interscript-ts
- No automated check that the website renders the new map

## Fix

Add a cross-repo CI job that runs after IR regeneration:
1. Download the regenerated IR
2. Run interscript-ts parity suite against it
3. Build the interscript.org site with the new IR + catalogue
4. Verify the new map's detail page renders without error

This catches JSON-IR shape mismatches before they hit production.

## Acceptance

- [ ] CI workflow exists in `interscript/maps`
- [ ] Runs interscript-ts test suite against the new IR
- [ ] Builds the site and checks the new map page
- [ ] Reports failures with actionable diagnostics
