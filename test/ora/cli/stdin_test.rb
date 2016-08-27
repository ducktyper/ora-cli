require 'test_helper'

class BashTest < Minitest::Test
  def test_gets
    stdin = subject ['input1', 'input2']
    assert_equal 'input1', stdin.gets
    assert_equal 'input2', stdin.gets
  end

  def test_pattern_retry
    stdin = subject ['none_number', '12345']
    assert_equal '12345', stdin.gets(/^\d+$/)
  end

  private
  def subject(inputs = [])
    Stdin.new(inputs, print: Print.new(true))
  end
end
