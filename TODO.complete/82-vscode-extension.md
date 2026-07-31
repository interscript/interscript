# 82 — VS Code extension

**Status:** TODO
**Priority:** P3

## Problem

Power users (especially in editorial / academic workflows) want
right-click transliteration inside their editor.

## Approach

Small VS Code extension:
- Select text → command palette → "Interscript: Transliterate"
- Choose system from a quick-pick
- Replace selection with output
- Configurable default system per language id

Uses interscript-ts under the hood. Loads maps from CDN via httpStrategy.

## Acceptance

- [ ] Published to VS Code marketplace
- [ ] README with demo gif
- [ ] Specs for the command
