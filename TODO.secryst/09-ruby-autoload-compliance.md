# secryst-v2: 09 — Ruby autoload compliance

**Status:** SPECIFICATION
**Priority:** P0

## Same rules as rababa (TODO.rababa/11)

The Ruby side (`interscript-ruby/lib/interscript/stdlib.rb`) must use
`autoload` for all internal library code. No `require_relative`.

## Current secryst integration

```ruby
# lib/interscript/stdlib.rb — current
def self.secryst(output, model:)
  begin
    require "secryst"  # OK: external gem
  rescue
    nil
  end
  ...
end
```

The `require "secryst"` is for the external gem — that's fine. But
if we add adapter modules for the new ML pipeline:

```ruby
# CORRECT — autoload in parent file
# lib/interscript/stdlib.rb
class Interscript::Stdlib
  module Functions
    autoload :RababaAdapter, "interscript/stdlib/functions/rababa_adapter"
    autoload :SecrystAdapter, "interscript/stdlib/functions/secryst_adapter"
  end
end

# lib/interscript/stdlib/functions/secryst_adapter.rb
class Interscript::Stdlib::Functions::SecrystAdapter
  def self.call(output, model:)
    # ... delegate to the external secryst gem or new ML pipeline
  end
end
```

**No `require_relative` anywhere in `lib/interscript/`.**

## Parent namespace files

Ensure these exist and have autoload entries:
- `lib/interscript/stdlib.rb` → autoloads `Functions`
- `lib/interscript/stdlib/functions.rb` → autoloads each adapter
  (create this file if it doesn't exist)
- `lib/interscript/stdlib/functions/rababa_adapter.rb` → implementation
- `lib/interscript/stdlib/functions/secryst_adapter.rb` → implementation

## Acceptance

- [ ] Zero `require_relative` in `lib/interscript/`
- [ ] Zero internal `require` calls (external gems are OK)
- [ ] Parent namespace files exist with autoload entries
- [ ] Specs pass with lazy autoload
- [ ] No `send` to private methods, no `instance_variable_set/get`,
      no `respond_to?` for type checking
