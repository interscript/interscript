# 78 — Reverse transliteration in TS

**Status:** TODO
**Priority:** P2

## Problem

Ruby supports `Interscript::Node::Rule::Sub#reverse` which inverts
maps (Latin → source). The TS runtime has no equivalent. Currently
skipped.

## Fix

Port the Ruby reverse algorithm from
`interscript-ruby/lib/interscript/node/rule/sub.rb`:
- Swap from/to
- Reverse transfer capture-group references
- Move boundary aliases into before/after clauses

Most maps can be reversed automatically. Some can't (lossy ones, e.g.
Arabic without diacritics → with).

## Public API

```typescript
transliterate(SC, input)         // forward (current)
transliterateReverse(SC, input)  // reverse
```

Some maps mark `reverse_run: true` to opt out.

## Acceptance

- [ ] `reverseTransliterate` works for maps that allow it
- [ ] Map metadata exposed via `canReverse(SC)` query
- [ ] Specs check round-trip identity where allowed
- [ ] New `/reverse` page on the site (was placeholder)
