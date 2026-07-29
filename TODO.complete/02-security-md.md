# 02 — Add `SECURITY.md` to all active repos

**Status:** DONE

## Why
No `SECURITY.md` existed in any of the 7 active code repos. Without one, GitHub doesn't surface a private vulnerability reporting path, and researchers have no clear disclosure instructions.

## Action taken
Wrote a single canonical `SECURITY.md` and committed it to each repo's existing `chore/best-practices-2026` branch (the branch already had an open upgrade PR). Bundling avoids 7 extra PRs.

## Files committed
- `maps/SECURITY.md` → bundled into interscript/maps#178
- `interscript-ruby/SECURITY.md` → bundled into interscript/interscript-ruby#755
- `interscript-js/SECURITY.md` → bundled into interscript/interscript-js#26
- `interscript/SECURITY.md` (monorepo) → bundled into interscript/interscript#3
- `rababa/SECURITY.md` → bundled into interscript/rababa#50
- `interscript-api/SECURITY.md` → bundled into interscript/interscript-api#26
- `interscript.org/SECURITY.md` → bundled into interscript/interscript.github.io#111

## Canonical content
- Supported versions: latest release
- Reporting: GitHub Security Advisories (preferred) or open.source@ribose.com
- SLA: 72-hour ack, 30-day target for critical fixes
- Coordinated disclosure supported

## Validation
All 7 PRs now show 2-3 commits with `docs: add SECURITY.md` as the latest.

## Non-goals
- GitHub org-level `SECURITY.md` (works as fallback for repos without one) — separate governance task.
