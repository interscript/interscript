# 83 — CLI library automation (MARC / CSV / Excel)

**Status:** TODO
**Priority:** P2

## Problem

`interscript-ts batch` handles plain text. Real-world workflows use
MARC (libraries), CSV (any data tool), Excel (business).

## Fix

Extend CLI with format-aware batch:
- `interscript-ts batch ... --format=csv --column=name --system=...`
- `interscript-ts marc ... --field=100 --system=...`
- `interscript-ts xlsx ... --sheet=Sheet1 --column=B --system=...`

Each format gets a small adapter; the transliteration loop is shared.

## Acceptance

- [ ] CSV input/output (with column picker)
- [ ] MARC text-mode input (one record per line)
- [ ] Excel input via `xlsx` or `exceljs`
- [ ] Documented on /api page
