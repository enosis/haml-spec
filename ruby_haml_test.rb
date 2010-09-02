require "test/unit"
require "json"
require "haml"

class HamlTest < Test::Unit::TestCase
  contexts = JSON.parse(File.read(File.dirname(__FILE__) + "/tests.json"))
  contexts.each do |context|
    context[1].each do |name, test|
      class_eval(<<-EOTEST)
        def test_#{name.gsub(/\s+|[^a-zA-Z0-9_]/, "_")}
          locals = Hash[*(#{test["locals"].inspect} || {}).collect {|k, v| [k.to_sym, v] }.flatten]
          options = Hash[*(#{test["config"].inspect} || {}).collect {|k, v| [k.to_sym, v.to_sym] }.flatten]
          engine = Haml::Engine.new(%q^#{test["haml"]}^, options)
          assert_equal(%q^#{test["html"]}^, engine.render(Object.new, locals).chomp)
        end
      EOTEST
    end
  end
end
