base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir  = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")

$LOAD_PATH.unshift(lib_dir)

require 'test/unit'
require 'rubygems'
require 'thrift'
require 'finagle-thrift'

# needs jruby for true test
def create_race_condition
  10.times.map do
    Thread.new do
      100.times { yield }
    end
  end.each(&:join)
end