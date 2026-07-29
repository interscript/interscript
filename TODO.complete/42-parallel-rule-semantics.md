# 42 — Parallel rule semantics in interscript-ts

**Status:** DEFERRED — design study needed

## Problem
2/5 sample maps produce slightly different output than Ruby:
- `alalc-amh-Ethi-Latn-2011`: ኢትዮጵያ → `ʼiyoyā` (TS) vs `ʼiteyop̣eyā` (Ruby)
- `un-tam-Taml-Latn-1972`: தமிழ் → `taml̮` (TS) vs `tamil̮` (Ruby)

## Root cause
The Ruby interpreter implements `Interscript::Node::Group::Parallel` via a tree-based single-pass algorithm (`Interscript::Stdlib.parallel_replace_compile_tree` + `parallel_replace_tree`). All sub-rules in a parallel block are applied simultaneously, longest-from-first, with no re-application of earlier rules to substituted text.

The TS runtime currently executes parallel rules sequentially (each sub-rule runs in order, with re-application). This causes differences when:
- Multiple rules could match overlapping substrings
- Diacritic combining marks need atomic substitution
- Map authors rely on parallel semantics for disambiguation

## Approach
Port `Interscript::Stdlib.parallel_replace_compile_tree` and `parallel_replace_tree` from Ruby (`lib/interscript/stdlib.rb`). Build a character trie from `(from, to)` pairs; walk input character-by-character against the trie.

## Files affected
- `src/stdlib.ts`: add `parallelReplaceTree` function
- `src/runtime/executor.ts`: `parallel` case uses tree-based replacement
- `test/stdlib.test.ts`: comprehensive tree tests
- `test/parity.test.ts`: remove `KNOWN_PARTIAL` entries as they pass

## Acceptance
- All 5 sample maps achieve byte-exact Ruby parity
- `KNOWN_PARTIAL` set is empty
- Coverage of `parallelReplaceTree` ≥ 90%

## Effort
M (1-2 days for a careful port + tests)
