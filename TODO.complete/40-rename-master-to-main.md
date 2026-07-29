# 40 — Rename `master` → `main` on remaining repos

**Status:** TODO — non-urgent

## Why
Code consistency. Most interscript repos use `main`; a few still use `master`:
- `Onigmo` (archived — skip)
- `opal` (archived — skip)
- `opal-onigmo` (archived — skip)
- `opal-webassembly` (archived — skip)
- `rambling-trie` (archived — skip)

After archiving, only `interoperable-transliteration-docs` might still use `master`. Verify and rename if so.

## Why defer
Branch rename is a force-push to all contributors' clones. Low urgency since the active repos all use `main` already.

## Process
1. Update local default
2. `git branch -m master main && git push -u origin main`
3. Update GitHub default branch via `gh repo edit --default-branch main`
4. Delete old `master` remote
5. Update any CI workflows that reference `master`

## Effort
S per repo (5-10 minutes)
