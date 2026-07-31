# rababa-v2: 11 — Ruby autoload integration (code quality mandate)

**Status:** SPECIFICATION
**Priority:** P0

## Goal

Ensure the Ruby side (interscript-ruby) follows strict autoload
conventions for the rababa/secryst ML function integration. No
`require_relative`, no `require` for internal library code.

## Rules (from project conventions)

1. **Never use `require_relative` for internal library code.** Use
   Ruby `autoload` instead.
2. **Never use `require` with a path to code within the library.**
   Use `autoload`.
3. **Define autoload entries in the immediate parent namespace's file.**
   Create the file if it doesn't exist.
4. **Never use `send` to call private methods.** Redesign if needed.
5. **Never use `instance_variable_set` or `instance_variable_get`.**
   Add public accessors.
6. **Never use `respond_to?` for type checking.** Use `is_a?` or
   design the type hierarchy so checks aren't needed.

## Current violations in interscript-ruby

```ruby
# lib/interscript/stdlib.rb — VIOLATION: require_relative
require "interscript"  # this is OK (external)
# But internal requires like these should be autoloads:
require_relative "something"  # VIOLATION
```

Check and fix:
```bash
grep -rn "require_relative" lib/interscript/  # find violations
grep -rn "require \"" lib/interscript/ | grep -v "^[^:]*:require \"[a-z]"  # internal requires
```

## Fix pattern

```ruby
# lib/interscript.rb (parent namespace file)
module Interscript
  # autoload every child constant here
  autoload :Stdlib,        "interscript/stdlib"
  autoload :Compiler,      "interscript/compiler"
  autoload :Interpreter,   "interscript/interpreter"
  autoload :Detector,      "interscript/detector"
  # ... etc
end

# lib/interscript/stdlib.rb
class Interscript::Stdlib
  # Don't require children — autoload them
  autoload :Functions, "interscript/stdlib/functions"
  # ...
end
```

## For ML integration specifically

When rababa/secryst functions are added to the Ruby stdlib:

```ruby
# lib/interscript/stdlib.rb — parent file
class Interscript::Stdlib
  module Functions
    autoload :RababaAdapter, "interscript/stdlib/functions/rababa_adapter"
    autoload :SecrystAdapter, "interscript/stdlib/functions/secryst_adapter"
  end
end
```

**No `require_relative` anywhere in the library.**

## Acceptance

- [ ] Zero `require_relative` calls in `lib/interscript/`
- [ ] Zero internal `require` calls (only autoload)
- [ ] Every namespace has autoload entries in its parent file
- [ ] Parent files created where they don't exist
- [ ] Specs pass with autoload (lazy loading works)
