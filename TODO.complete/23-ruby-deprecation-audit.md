# 23 — Ruby 4.0 deprecation audit across all gems

**Status:** DONE — no blockers found

## What was scanned
- `interscript-ruby/lib/**/*`
- `interscript-api/lib/**/*`
- `rababa/lib/**/*`
- `maps/` (no Ruby code)

## Patterns checked
| Pattern | Result |
|---------|--------|
| `Fixnum`/`Bignum` constants | None |
| `BigDecimal.new` (removed 3.4) | None |
| `File.exists?` (removed 2.1) | None |
| `ObjectSpace.trace_object_allocations` quirks | None |
| `RubyVM::FrozenCore`/`RubyVM::VM` | None |
| Positional hash-as-kwargs (2.x → 3.x migration) | One (see below) |
| Deprecated `Net::HTTP.new` 2-arg form | None |
| `$1`/`$~` regex globals | Used in `dsl.rb:63` (md_indent = $1) — works on 4.0 but stylistically discouraged |

## One observation: positional hash before kwargs
`interscript-ruby/lib/interscript.rb`:
```ruby
def load(system_code, maps = {}, compiler: Interscript::Interpreter)
def transliterate(system_code, string, maps = {}, compiler: Interscript::Interpreter)
def transliterate_file(system_code, input_file, output_file, maps = {}, compiler: ...)
```

This is **legal Ruby 3.x** but a known foot-gun for callers upgrading from 2.x:
- In Ruby 2.x: `load('foo', compiler: Foo)` was treated as `maps = {compiler: Foo}` (merged kwargs into positional hash).
- In Ruby 3.x: kwargs are separated, so this call correctly passes `compiler: Foo` as the keyword.

For the published API, both work. No action needed for Ruby 4.0 — kwargs separation is stable since 3.0.

## Stale-file cleanup
- Removed `lib/interscript-api/graphql/types/query_type.rb` — leftover from the lambda/GraphQL refactor in TODO 11. `query.rb` is the new home.

## Conclusion
No code changes required for Ruby 4.0 readiness. The 3.3 → 3.4 floor bump is the only preparation needed.

## Ongoing
- StandardRB and ESLint rules (`Style/HashSyntax` etc.) will catch future deprecated patterns at PR time.
