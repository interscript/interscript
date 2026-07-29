# 22 — CodeQL static analysis workflows

**Status:** DONE

## Action taken
Added `.github/workflows/codeql.yml` to 5 repos:

| Repo | Language | Schedule |
|------|----------|----------|
| maps | ruby | weekly |
| interscript-ruby | ruby | weekly |
| rababa | ruby | weekly |
| interscript-api | ruby | weekly |
| interscript-js | javascript | weekly |

## Workflow shape
```yaml
on:
  push: { branches: [main] }
  pull_request:
  schedule: [{ cron: "0 0 * * 0" }]  # weekly Sunday

permissions:
  actions: read
  contents: read
  security-events: write

jobs:
  analyze:
    uses: github/codeql-action/init@v3
    uses: github/codeql-action/analyze@v3
```

## Why
- Catches common security issues (SQL injection patterns, unsanitized exec, etc.) before merge
- GitHub-native: integrates with Security tab
- Weekly cron catches new vulnerabilities discovered in deps

## Validation
- All 5 workflows committed to existing PR branches
- Will start scanning on next push to main (after PRs merge)
- Results visible at github.com/<repo>/security/code-scanning
