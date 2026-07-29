# 04 — Dependabot security alerts + automated fixes

**Status:** DONE

## Action taken
Enabled both via `gh api` for all 10 active repos:

```bash
gh api -X PUT /repos/interscript/<repo>/vulnerability-alerts
gh api -X PUT /repos/interscript/<repo>/automated-security-fixes
```

## Coverage
| Repo | Alerts | Auto-fixes |
|------|--------|------------|
| maps | ✅ | ✅ |
| interscript-ruby | ✅ | ✅ |
| interscript-js | ✅ | ✅ |
| interscript (monorepo) | ✅ | ✅ |
| interscript-api | ✅ | ✅ |
| interscript.github.io | ✅ | ✅ |
| rababa | ✅ | ✅ |
| Onigmo | ✅ | ✅ |
| opal | ✅ | ✅ |
| geonames-transliteration-data | ✅ | ✅ |

## Validation
All 20 PUT requests returned 204 (success, no content).

## Notes
- Repo-level `.github/dependabot.yml` (added in Wave 0) controls update schedule.
- These API endpoints enable GitHub's security alert dashboard and auto-PR generation for vulnerable deps.
- Combined with weekly Dependabot update PRs (from config files), this gives full coverage.
