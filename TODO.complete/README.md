# TODO — Interscript Modernization

Indexed task list for all modernization work. Each file documents one task: rationale, actions taken, status, follow-ups.

Status legend: **DONE** · **DEFERRED** · **BLOCKED** · **TODO** · **READY**

## Wave 1 — Initial best-practices sweep (2026-07-28)

| # | Task | Status |
|---|------|--------|
| [01](01-purge-deploy-key.md) | Purge local `deploy_key` from `interoperable-transliteration-docs` | DONE |
| [02](02-security-md.md) | Add `SECURITY.md` to all active repos | DONE |
| [03](03-branch-protection.md) | Branch protection on `main` for all upgraded repos | BLOCKED → see [41](41-branch-protection-ready.md) |
| [04](04-dependabot-alerts.md) | Enable Dependabot security alerts per repo | DONE |
| [05](05-oidc-trusted-publishing.md) | OIDC trusted publishing for RubyGems + npm | DEFERRED |
| [06](06-standardrb-ruby-gems.md) | StandardRB in CI for all Ruby gems | DONE |
| [07](07-eslint-interscript-js.md) | ESLint + Prettier for `interscript-js` | DONE |
| [08](08-ruff-rababa-python.md) | ruff baseline for `rababa/python` | DONE |
| [09](09-specs-coverage.md) | Improve spec coverage gaps | ONGOING |
| [10](10-lambda-docker-ruby34.md) | Lambda Docker base 2.7 → 3.4 | DONE |
| [11](11-interscript-api-ruby4-ready.md) | `interscript-api` Ruby 4.0 readiness | DONE |
| [12](12-graphql-2x.md) | GraphQL 1.x → 2.x | DEFERRED |
| [13](13-interscript-gem-2x.md) | `interscript` 0.1.9 → 2.x in api | DEFERRED |
| [14](14-docker-actions-replace.md) | Replace `elgohr/Publish-Docker-Github-Action` | DONE |
| [15](15-contributing-md.md) | `CONTRIBUTING.md` across repos | DONE |
| [16](16-ci-badges.md) | CI status badges in READMEs | DONE |
| [17](17-changelog-md.md) | `CHANGELOG.md` in release repos | DONE |
| [18](18-repo-metadata.md) | Repo metadata consistency | DONE |
| [19](19-torch-2x.md) | `rababa/python` torch 1.9 → 2.x | DEFERRED |
| [20](20-esm-cjs-packaging.md) | `interscript-js` dual ESM/CJS + provenance | DEFERRED (superseded by interscript-ts) |
| [21](21-architectural-review.md) | OCP/MECE/DRY review | DONE |
| [22](22-codeql-static-analysis.md) | CodeQL workflows | DONE |
| [23](23-ruby-deprecation-audit.md) | Ruby 4.0 deprecation audit | DONE |
| [24](24-ts-runtime-port.md) | TS runtime port for `interscript-js` | DEFERRED (superseded by interscript-ts) |
| [25](25-astro-migration.md) | Astro migration for `interscript.org` | DEFERRED (superseded by interscript.org-v2) |
| [26](26-archive-dead-repos.md) | Archive dead repos (issue [#4](https://github.com/interscript/interscript/issues/4)) | DEFERRED |

## Wave 2 — Merge + archive + new initiatives (2026-07-29)

| # | Task | Status |
|---|------|--------|
| [27](27-merge-all-prs.md) | Rebase-merge all 8 upgrade PRs; close 2 opal PRs | DONE |
| [28](28-archive-opal-repos.md) | Archive 5 opal-related repos | DONE |
| [29](29-interscript-ts-scaffold.md) | Scaffold `interscript-ts` (TypeScript runtime) | DONE |
| [30](30-interscript-org-v2-scaffold.md) | Scaffold `interscript.org-v2` (Astro 7 + Vue + Tailwind 4) | DONE |
| [31](31-ruby-json-ir-compiler.md) | Ruby JSON IR compiler (enables full TS parity) | TODO |
| [32](32-detector-implementation.md) | Detector implementation in `interscript-ts` | TODO |
| [33](33-dsl-parser.md) | DSL parser for `.imp` files (full Ruby parity) | TODO (large) |
| [34](34-interscript-ts-cli.md) | interscript-ts CLI | TODO |
| [35](35-interscript-ts-publish.md) | interscript-ts npm publish + provenance | READY |
| [36](36-port-legacy-site-content.md) | Port content from legacy site to v2 | TODO |
| [37](37-wire-interscript-ts-to-vue.md) | Wire interscript-ts into Vue map explorer | TODO (blocked by 31) |
| [38](38-deprecate-interscript-js.md) | Deprecate `interscript-js` in favor of `interscript-ts` | TODO (gated by v1.0) |
| [39](39-interscript-ts-coverage.md) | Spec coverage baseline for interscript-ts | ONGOING |
| [40](40-rename-master-to-main.md) | Rename `master` → `main` on remaining repos | TODO |
| [41](41-branch-protection-ready.md) | Branch protection (now unblocked) | READY |

## Quick links

- Wave 1 plan: [docs/superpowers/plans/2026-07-28-best-practices-upgrade.md](../docs/superpowers/plans/2026-07-28-best-practices-upgrade.md)
- Wave 2 plan: [docs/superpowers/plans/2026-07-29-follow-up-modernization.md](../docs/superpowers/plans/2026-07-29-follow-up-modernization.md)
- Tracking issue: https://github.com/interscript/interscript/issues/4
