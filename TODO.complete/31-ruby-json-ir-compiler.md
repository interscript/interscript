# 31 — Ruby JSON IR compiler (enables full TS parity)

**Status:** TODO — required for real parity tests

## Why
The TS interpreter consumes `CompiledMap` JSON IR. Today, no Ruby compiler emits this format. The Ruby gem has `Compiler::Javascript` (emits JS code) and `Compiler::Ruby` (emits Ruby code). We need a third: `Compiler::JsonIR` that emits pure data.

## Scope

### Ruby side (`interscript-ruby`)
Add `lib/interscript/compiler/json_ir.rb`:

```ruby
class Interscript::Compiler::JsonIR < Interscript::Compiler
  SchemaVersion = 1

  def compile(map, debug: false)
    @map = map
    @c = {
      schemaVersion: SchemaVersion,
      systemCode: map.name,
      dependencies: map.dependencies.map(&:full_name),
      metadata: extract_metadata(map),
      stages: map.stages.map { |s| serialize_stage(s) },
      aliases: serialize_aliases(map),
      functions: serialize_functions(map),
    }
    self
  end

  def code
    JSON.generate(@c)
  end

  private

  def serialize_stage(stage)
    {
      kind: "stage",
      name: stage.name.to_s,
      rules: stage.rules.map { |r| serialize_rule(r) },
    }
  end

  def serialize_rule(rule)
    case rule
    when Interscript::Node::Rule::Sub
      {
        kind: "sub",
        from: serialize_item(rule.from),
        to: serialize_item(rule.to),
        before: rule.before ? serialize_item(rule.before) : nil,
        # ... etc
      }.compact
    when Interscript::Node::Rule::Run
      { kind: "run", stage: rule.stage.name.to_s }
    when Interscript::Node::Rule::Funcall
      { kind: "funcall", name: rule.name.to_s, kwargs: rule.kwargs }
    else
      raise "Cannot serialize #{rule.class}"
    end
  end

  def serialize_item(item)
    case item
    when Interscript::Node::Item::String
      { kind: "string", value: item.data }
    when Interscript::Node::Item::Capture
      { kind: "capture", index: item.id }
    when Interscript::Node::Item::Alias
      { kind: "alias", name: item.name.to_s }
    # ... etc
    end
  end
end
```

### Ruby Rake task
Add to `interscript-ruby/Rakefile`:
```ruby
task :compile_json_ir, [:target] do |t, args|
  require "interscript/compiler/json_ir"
  FileUtils.mkdir_p(args[:target])
  maps = Interscript.maps(load_path: true)
  parallel_args = maps.map { |m| [m, "#{args[:target]}/#{m}.json"] }
  # ...
end
```

### TS side (`interscript-ts`)
Add `src/loaders/json-ir-loader.ts`:
```typescript
import { readFileSync } from "node:fs"
import type { CompiledMap, LoadStrategy } from "../index.js"

export function filesystemJsonIRStrategy(dir: string): LoadStrategy {
  return (systemCode) => {
    try {
      const raw = readFileSync(`${dir}/${systemCode}.json`, "utf8")
      return JSON.parse(raw) as CompiledMap
    } catch {
      return undefined
    }
  }
}
```

### Map package
Either:
- (a) Embed JSON IR into `interscript-ts/maps/` at build time, or
- (b) Publish a separate npm package `interscript-maps` with all IR files

Option (b) is cleaner — keeps map data separate from runtime code.

## Acceptance criteria
- `bundle exec rake compile_json_ir[../maps-ir]` produces JSON files for all maps
- `interscript-ts` can load those JSON files via filesystemJsonIRStrategy
- All parity fixtures pass (95%+ of Ruby's spec cases)

## Effort
M (1-2 days). Mostly mechanical translation from `Compiler::Javascript` (which already walks the AST).
