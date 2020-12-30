module Interscript::DSL
  @cache = {}
  def self.parse(map_name)
    # map name aliases? here may be a place to wrap it

    return @cache[map_name] if @cache[map_name]
    path = Interscript.locate(map_name)

    obj = Interscript::DSL::Document.new
    obj.instance_eval File.read(path), File.expand_path(path, Dir.pwd), 1
    @cache[map_name] = obj.node
  end
end

require 'interscript/dsl/items'

require 'interscript/dsl/document'
require 'interscript/dsl/group'
require 'interscript/dsl/stage'
require 'interscript/dsl/metadata'
require 'interscript/dsl/tests'
require 'interscript/dsl/aliases'
