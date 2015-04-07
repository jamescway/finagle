require_relative 'test_helper'

class TraceIdTest < Test::Unit::TestCase
  def test_debug_flag
    id = Trace::TraceId.new(0, 1, 2, false, Trace::Flags::DEBUG)
    assert_equal true, id.debug?
    assert_equal true, id.next_id.debug?
    # the passed in sampled is overriden if debug is true
    assert_equal true, id.sampled?
    assert_equal true, id.next_id.sampled?

    id = Trace::TraceId.new(0, 1, 2, false, Trace::Flags::EMPTY)
    assert_equal false, id.debug?
    assert_equal false, id.next_id.debug?
  end

  def test_span_id
    id = Trace::SpanId.new(Trace.generate_id)
    id2 = Trace::SpanId.from_value(id.to_s)
    assert_equal id.to_i, id2.to_i
  end
end

class TraceTest < Test::Unit::TestCase
  def setup
    Trace.instance_variable_set(:@stack, ThreadSafe::Array.new)
  end

  def test_push
    id = Trace::TraceId.new(0, 1, 2, false, Trace::Flags::DEBUG)
    create_race_condition { Trace.push(id) { true } }
    stack = Trace.instance_variable_get(:@stack)
    assert_equal stack.size, 0
  end

  def test_id
    create_race_condition { Trace.id }
    stack = Trace.instance_variable_get(:@stack)
    assert_equal stack.size, 1
  end

  def test_unwind
    create_race_condition { Trace.unwind { true } }
    stack = Trace.instance_variable_get(:@stack)
    assert_equal stack.size, 0
  end
end
