require 'test_helper'
require 'ora/cli/stdin'

class StdinTest < Minitest::Test
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
    print = Print.new(true)
    bash  = Bash.new(self, from: 'tmp', print: print)
    Stdin.new(bash: bash, print: print, inputs: inputs)
  end
end
