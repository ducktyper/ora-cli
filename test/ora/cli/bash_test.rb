require 'test_helper'

class BashTest < Minitest::Test
  def setup
    `rm -rf tmp && mkdir tmp`
  end

  def teardown
    `rm -rf tmp`
  end

  def test_run_command_in_param
    bash.bash('touch create_file_test.txt', print: Print.new(true))
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_output
    assert bash.bash('pwd', print: Print.new(true)).include?('tmp')
  end

  def test_block
    output = bash.bash(print: Print.new(true)) do
      'pwd'
    end
    assert output.include?('tmp')
  end

  def test_capture_errors
    assert bash.bash('rm unknown.file', print: Print.new(true)).include?('No such file or directory')
  end

  def test_stop_run_rest_on_error
    bash.bash('
      rm unknown.file
      touch never-create.txt
    ', print: Print.new(true))
    assert !bash.bash('ls', print: Print.new(true)).include?('never-create.txt')
  end

  def test_call_method
    bash.bash(':touch_file_a', print: Print.new(true))
    assert `ls tmp`.include?("file_a")
  end

  def test_call_method_failed
    bash.bash('
      :return_false
      touch file_b
    ', print: Print.new(true))
    assert !`ls tmp`.include?("file_b")
  end

  def test_return_minimise_empty_lines
    assert_equal "a", bash.bash('
      echo ""
      echo "a"
    ', print: Print.new(true))
  end

  def test_inline_method
    assert bash.bash('#{inline_method}', print: Print.new(true)).include?("tmp")
  end

  private
  def bash
    Bash.new(self, from: "tmp")
  end

  def touch_file_a
    Bash.new(self, from: "tmp").bash('touch file_a', print: Print.new(true))
  end

  def return_false
    false
  end

  def inline_method
    "pwd"
  end
end
