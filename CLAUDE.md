# CLAUDE.md — interscript (project monorepo)

This repository is the Interscript project monorepo: bootstrap,
integration specs, docs, website sources, and the historical home of
the runtimes. The runtimes, corpus, models, and API live in their own
repositories:

- `interscript/maps` — the corpus (293 authority systems, `.isc`,
  single source of truth)
- `interscript/interscript-ruby` — Ruby gem (`interscript`)
- `interscript/interscript-ts` — npm package (`interscript`)
- `interscript/interscript-py` — Python package (`interscript`)
- `interscript/interscript-models` — neural-layer contract, model zoo,
  training spine (`isxml`), campaign ledger (`TODO.sota/`)
- `interscript/api` + `api.interscript.org` — the public API
  (Cloudflare Workers)

Project purpose and direction: `interscript-models` README.

## Facts that bite

- `bootstrap.rb` assembles the integrated tree (ruby/ + js/) for the
  cross-package CI; the runtimes' own repos are canonical for their
  code — fixes land there, not here.
- Release plumbing per platform uses trusted publishing (npm OIDC,
  RubyGems release-gem, PyPI trusted publishing). No API-key secrets.
- The website serves from this repo's `website/` lineage; dead nav
  paths are bugs, not redirects.

## Laws

- PRs only, never commit to main. Versions and releases are owner
  decisions.
- Data channel: GitHub Releases only — never raw.githubusercontent.com
  for any data path.
- Do not delete "unused" files, docs, or demo assets; archive and
  suggest instead.
