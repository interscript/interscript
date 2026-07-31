# 81 — Map editing playground (no-code authoring)

**Status:** TODO
**Priority:** P3

## Problem

Adding a new map requires writing Ruby DSL code. For domain experts
(linguists, librarians) who aren't developers, this is a barrier.

## Approach

A no-code map editor on the website:
- Drag-drop rules from a palette (sub, parallel, run, funcall)
- Live preview against test vectors
- Export as Ruby DSL or JSON IR
- Optional: open a PR directly from the editor

This is a significant UI project. Could be a great internship or
community-contributor task.

## Acceptance

- [ ] Editor at `/author`
- [ ] Can build a small map end-to-end (e.g. a 5-rule Latin-to-Latin
  normalization map)
- [ ] Live preview shows output for any test input
- [ ] Export as DSL + IR
- [ ] Optional: GitHub PR opener via API
