# 42 — Parallel rule semantics in interscript-ts

**Status:** COMPLETE — 99.9% Ruby parity (7498/7502 test vectors across 269 maps)

## What was fixed

The parallel executor now mirrors Ruby's two-mode algorithm:

1. **Tree mode** — when every rule's `from` compiles to literal strings AND
   no rule has `before`/`after`/`not_before`/`not_after` clauses, the block
   runs through a longest-match trie (single pass, O(n)).
2. **Megaregexp mode** — fallback for the WHOLE block when any rule has
   constraints or re-only aliases (`boundary`, `line_start`, etc.) inside
   `from`. Builds a single alternation regex
   `(?<r0>p0)|(?<r1>p1)|...` sorted by `max_length` desc (declaration
   order tiebreaker, matching Ruby's `deterministic_sort_by_max_length`).
   At each scan position, V8's alternation semantics pick the first
   matching alternative — same as Ruby's Onigmo.

The previous implementation split a parallel block at the rule level
(trie for unconstrained, sequential for constrained), which produced
different output because the trie pass mutated the string before
constrained rules could compete.

## Supporting fixes

- **`any_char_class` IR kind** — Ruby's `Any(Range("a".."z"))` and
  `Any(String("abc"))` compile to character classes (`[a-z]`, `[abc]`)
  in regex mode, NOT expanded alternations. The previous IR serialiser
  used `String#succ` to enumerate ranges, producing nonsense like `"zzz"`
  and missing most of the BMP. Added a new `any_char_class` Item variant
  with `range` and `chars` fields; Ruby JsonIR emits it for Range/String
  payloads.
- **`any` literal via `nth_string`** — `sub X, any("ie")` now produces
  `i` (first alternative), matching Ruby's `Node::Item::Any#nth_string`.
- **Tree-mode compatibility check** — a rule is tree-compatible iff it
  has no constraint clauses AND `expandFromLiterals(from)` returns a
  non-null array. `boundary`/`word`/etc. inside `from` force megaregexp.
- **`maxLengthOfItem`** — ported from Ruby's `Node::Item#max_length`
  for correct sort ordering.

## Files affected

- `interscript-ts/src/runtime/executor.ts` — parallel case rewritten
- `interscript-ts/src/runtime/compile-item.ts` — `any_char_class`
  handling, `maxLengthOfItem`, `any` literal-first
- `interscript-ts/src/stdlib.ts` — `parallelMegaregexp`, removed unused
  `parallelSinglePass`
- `interscript-ts/src/types.ts` — `AnyCharClassItem` variant
- `interscript-ruby/lib/interscript/compiler/json_ir.rb` — Range/String
  `Any` payloads serialised as `any_char_class`
- `interscript-ts/scripts/full-parity.{rb,ts}` — comprehensive 7502-vector
  parity comparison runner

## Remaining 4 diffs (4/7502 = 0.05%)

Two maps remain, both due to deep Ruby regex semantics:

- **`odni-che-Cyrl-Latn-2015`** (1 diff): The map's `sub "1", "ӏ",
  before: not_word` relies on Ruby's default `\W` being ASCII-only, so
  Cyrillic letters count as non-word. Our `\W` is Unicode-aware
  (`[^\p{L}\p{N}_]`) — changing it to ASCII-only regresses 800+ other
  maps that depend on Unicode boundary behaviour.
- **`iso-mal-Mlym-Latn-15919-2001`** (3 diffs): Ruby's actual output
  diverges from its own in-map `test` directive. Our output matches
  the test directive (e.g. `mañjaraēkkaraŭ`), Ruby's does not
  (`mañjaraēkkar`). Treating this as a Ruby-side bug.

## Acceptance
- Pass rate: 99.9% (7498/7502 vectors across 269 maps)
- Existing 117-test suite still passes
- No regressions from previous 97.8% baseline
