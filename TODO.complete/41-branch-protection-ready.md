# 41 — Branch protection on all repos (now unblocked)

**Status:** READY — previous PRs are now merged, so branch protection won't block them

## Why
TODO 03 was blocked on PR merges. All 8 upgrade PRs are now in. Time to enable branch protection.

## Plan
For each upgraded repo, apply:

```bash
gh api -X PUT /repos/interscript/<repo>/branches/main/protection \
  -F "required_status_checks[strict]=true" \
  -F "required_status_checks[checks][]=<workflow>-test/rake" \
  -F "enforce_admins=false" \
  -F "required_pull_request_reviews[dismiss_stale_reviews]=false" \
  -F "required_pull_request_reviews[require_code_owner_reviews]=false" \
  -F "restrictions=null" \
  -F "required_linear_history=true" \
  -F "allow_force_pushes=false"
```

Per-repo status check names (use `gh api /repos/<repo>/branches/main/protection/required-status-checks-contexts` to discover actual names after first push).

## Repos to protect
- interscript/maps
- interscript/interscript-ruby
- interscript/interscript-js
- interscript/interscript (monorepo)
- interscript/interscript-api
- interscript/interscript.github.io (legacy)
- interscript/interscript.org-v2 (new)
- interscript/interscript-ts (new)
- interscript/rababa
- interscript/geonames-transliteration-data

Skip (archived): Onigmo, opal, opal-onigmo, opal-webassembly, rambling-trie

## Solo maintainer note
No required approving review count. PR is the gate, CI is the wall, maintainer approves their own PRs.

## Effort
S (10-15 minutes for all repos, scripted)
