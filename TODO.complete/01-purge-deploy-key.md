# 01 — Purge `deploy_key` from `interoperable-transliteration-docs`

**Status:** DONE

## Why
A 1823-byte OpenSSH private key (`deploy_key`) plus its public half (`deploy_key.pub`) sat untracked in the local working tree of `interoperable-transliteration-docs` since 2019-11.

## Investigation (2026-07-29)
- `git log --all -- deploy_key` returned empty → **never committed**. Not a public leak.
- Files were local-only clutter, no rotation required.
- `.gitignore` did not exist.

## Action taken
- `rm deploy_key deploy_key.pub` (local files only)
- Created `.gitignore` with:
  - `deploy_key`, `deploy_key.pub`, `*.pem`, `*.key` (defensive — no future key leaks)
  - Generated artifacts (`*.html`, `documents/`, `relaton/`, `.tmp.*`, `sources/images/`, `sources/plantuml/`) — these were already cluttering status
  - Standard OS/editor entries

## Validation
- `git status` now shows only legitimate new artifacts, no key material.
- `rg "BEGIN OPENSSH PRIVATE KEY|BEGIN RSA PRIVATE KEY|BEGIN EC PRIVATE KEY" interoperable-transliteration-docs/` → no matches.

## Non-goals
- No git history rewrite — there was nothing to purge.
- No key rotation — key was never published.

## Follow-up
- None.
