# 27 — Merge all upgrade PRs (rebase strategy)

**Status:** DONE

## Action taken
Closed opal-related PRs (repos being archived):
- interscript/opal#1
- interscript/Onigmo#2

Rebase-merged 8 PRs (each with `--rebase --delete-branch`):
- interscript/maps#178 ✓
- interscript/interscript-ruby#755 ✓
- interscript/interscript-js#26 ✓
- interscript/interscript#3 ✓ (monorepo root CI)
- interscript/rababa#50 ✓
- interscript/interscript-api#26 ✓
- interscript/interscript.github.io#111 ✓
- interscript/geonames-transliteration-data#14 ✓

## Result
All 8 satellite repos now have upgraded `main`:
- Ruby ≥ 3.3 floor (api + monorepo at 3.4)
- Modern GHA (checkout@v7, setup-node@v7, etc.)
- StandardRB / ESLint / ruff in CI
- CodeQL workflows
- SECURITY.md, CONTRIBUTING.md, CHANGELOG.md, CI badges
- Dependabot alerts + automated security fixes
- Repo metadata consistency

## Branch cleanup
All `chore/best-practices-2026` branches deleted post-merge.
