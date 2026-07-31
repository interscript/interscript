# 73 — Documentation: ARCHITECTURE.md

**Status:** TODO
**Priority:** P1

## Problem

The codebase has grown significantly. A new contributor needs to
understand:
- Where the boundaries are (Ruby DSL, JSON IR, TS runtime, website)
- The flow from authoring → IR → execution
- How to add: a new map, a new rule kind, a new ML model, a new loader
  strategy, a new website page

## Fix

Author `ARCHITECTURE.md` in each repo covering:

### interscript-ruby
- DSL → AST → Interpreter / Compiler
- JsonIR compiler shape + schema versioning
- Map corpus + library maps

### interscript-ts
- IR shape + loader strategies (sync, async, http, filesystem)
- Rule executor dispatch (parallel trie vs megaregexp)
- ML model abstraction (#61)
- CLI subcommands

### interscript.org
- Astro hybrid output + API endpoints
- Vue islands + Web Worker integration
- Service Worker caching strategy
- Map data flow (catalogue + IR + HTTP loader)

### interscript/maps
- How a map is authored
- Test directives
- CI pipeline (Ruby specs + IR regeneration + parity suite)

## Acceptance

- [ ] ARCHITECTURE.md exists in each repo
- [ ] Diagrams (mermaid or asciidoc) illustrate the flow
- [ ] Every "how do I add X" question has a section
