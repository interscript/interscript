# 17 — CHANGELOG.md in release repos

**Status:** DONE

## Action taken
Created `CHANGELOG.md` (Keep a Changelog 1.1.0 format) in 5 release repos:
- maps, interscript-ruby, interscript-js, rababa, interscript-api

Content:
- Header explaining format + semver link
- `[Unreleased]` section
- `[Latest]` section pointing to GitHub Releases

## Why
- Gemspec `changelog_uri` now points to `/releases` (set in Wave 0). The `CHANGELOG.md` is the local mirror for `keep-a-changelog` tooling and offline reference.
- Lower friction for users scanning what changed between versions.
