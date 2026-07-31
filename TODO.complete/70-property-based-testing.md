# 70 — Property-based + fuzz testing

**Status:** TODO
**Priority:** P2

## Problem

Current tests are example-based. Good for catching regressions to known
failures; weaker at finding new bugs in combinatorial spaces like
character-class regex compilation or megaregexp alternation.

## Fix

Add `fast-check` for property tests:

### interscript-ts

- **Megaregexp determinism**: for any (system, input) pair, two
  consecutive `transliterate()` calls return the same string
- **Trie consistency**: `parallelReplaceTree` longest-match is
  transitive — if A beats B and B beats C, A beats C
- **Reverse round-trip**: `transliterate(SC, reverse(transliterate(SC.reverse, x)))`
  equals x for reversible systems (where defined)
- **Encoder/decoder bijection**: Rababa's
  `input_to_sequence ∘ input_id_to_symbol` is identity on valid chars

### interscript.org

- **URL state sync**: any state reachable via UI is also reachable via
  URL params, and vice versa
- **Worker RPC**: every public client method has a paired worker
  message; verify round-trip for any input

## Acceptance

- [ ] `fast-check` installed in both repos
- [ ] 5+ property tests per repo
- [ ] CI runs them on every PR
