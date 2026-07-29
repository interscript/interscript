# 03 — Branch protection on `main` for all upgraded repos

**Status:** BLOCKED — must wait until the 10 open upgrade PRs merge

## Why
Branch protection forces PR review and CI gates before code lands on `main`. Without it, stray pushes to `main` are still possible.

## Why blocked
Enabling `required_pull_request_reviews` now would block merging the 10 already-open PRs (since the author is also the maintainer — solo review).

## Action plan (run after PRs merge)
For each repo, apply:

```bash
gh api -X PUT /repos/interscript/<repo>/branches/main/protection -F "required_status_checks[strict]=true" -F "required_status_checks[contexts[]=test" -F "required_status_checks[contexts[]=rake" -F "required_pull_request_reviews[dismiss_stale_reviews]=false" -F "required_pull_request_reviews[require_code_owner_reviews]=false" -F "enforce_admins=false" -F "restrictions=null" -F "required_linear_history=true" -F "allow_force_pushes=false" -F "required_conversation_resolution=false"
```

Per-repo `contexts[]` must match the actual workflow job names once merged:
- `maps`: `test`
- `interscript-ruby`: `rspec`
- `interscript-js`: `test`
- `interscript` (monorepo): `ruby (3.3)`, `ruby (3.4)`, `js (20)`, `js (22)`
- `rababa`: `build`
- `interscript-api`: `rspec`
- `interscript.org`: `build`

## Notes
- `enforce_admins=false` lets admins still merge in emergencies
- `required_linear_history=true` enforces squash/rebase merges (clean history)
- Solo maintainer: no required approving reviews; PR is the gate, CI is the wall
