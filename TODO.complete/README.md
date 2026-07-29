# TODO — Interscript Follow-Up Modernization

Indexed task list for the work following the 2026-07-28 best-practices sweep.
Each file in this directory documents one task: rationale, actions taken, status.

Status legend: **DONE** · **DEFERRED** · **BLOCKED**

## Priority 1 — Security (do first)

| # | Task | Status |
|---|------|--------|
| [01](01-purge-deploy-key.md) | Purge local `deploy_key` from `interoperable-transliteration-docs` | DONE |
| [02](02-security-md.md) | Add `SECURITY.md` to all active repos | DONE |
| [03](03-branch-protection.md) | Branch protection on `main` for all upgraded repos | BLOCKED |
| [04](04-dependabot-alerts.md) | Enable Dependabot security alerts per repo | DONE |
| [05](05-oidc-trusted-publishing.md) | OIDC trusted publishing for RubyGems + npm | DEFERRED |

## Priority 2 — Lint & code quality

| # | Task | Status |
|---|------|--------|
| [06](06-standardrb-ruby-gems.md) | StandardRB in CI for all Ruby gems | DONE |
| [07](07-eslint-interscript-js.md) | ESLint + Prettier for `interscript-js` | DONE |
| [08](08-ruff-rababa-python.md) | ruff baseline for `rababa/python` | DONE |
| [09](09-specs-coverage.md) | Improve spec coverage gaps | ONGOING |

## Priority 3 — `interscript-api` Ruby 4.0 readiness (user request)

| # | Task | Status |
|---|------|--------|
| [10](10-lambda-docker-ruby34.md) | Lambda Docker base 2.7 → 3.4 (Ruby 4.0-ready) | DONE |
| [11](11-interscript-api-ruby4-ready.md) | `interscript-api` audit for Ruby 4.0 | DONE |
| [12](12-graphql-2x.md) | GraphQL 1.x → 2.x | DEFERRED |
| [13](13-interscript-gem-2x.md) | `interscript` 0.1.9 → 2.x in api | DEFERRED |
| [14](14-docker-actions-replace.md) | Replace `elgohr/Publish-Docker-Github-Action` with official Docker actions | DONE |

## Priority 4 — Hygiene & docs

| # | Task | Status |
|---|------|--------|
| [15](15-contributing-md.md) | `CONTRIBUTING.md` across repos | DONE |
| [16](16-ci-badges.md) | CI status badges in READMEs | DONE |
| [17](17-changelog-md.md) | `CHANGELOG.md` in release repos | DONE |
| [18](18-repo-metadata.md) | Repo metadata consistency (description, topics) | DONE |

## Priority 5 — Breaking dependency upgrades

| # | Task | Status |
|---|------|--------|
| [19](19-torch-2x.md) | `rababa/python` torch 1.9 → 2.x | DEFERRED |
| [20](20-esm-cjs-packaging.md) | `interscript-js` dual ESM/CJS + provenance | DEFERRED |

## Priority 6 — Architecture & quality

| # | Task | Status |
|---|------|--------|
| [21](21-architectural-review.md) | OCP/MECE/DRY review of touched modules | DONE |
| [22](22-codeql-static-analysis.md) | CodeQL workflow for Ruby + JS | DONE |
| [23](23-ruby-deprecation-audit.md) | Ruby 4.0 deprecation audit across all gems | DONE |

## Priority 7 — Multi-day efforts (separate PR series)

| # | Task | Status |
|---|------|--------|
| [24](24-ts-runtime-port.md) | TS runtime port for `interscript-js` (Phase C2) | DEFERRED |
| [25](25-astro-migration.md) | Astro migration for `interscript.org` (Phase G2) | DEFERRED |
| [26](26-archive-dead-repos.md) | Archive dead repos (issue [#4](https://github.com/interscript/interscript/issues/4)) | DEFERRED |
