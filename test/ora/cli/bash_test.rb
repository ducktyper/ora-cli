require 'test_helper'

class BashTest < Minitest::Test
  def setup
    `rm -rf tmp && mkdir tmp`
  end

  def teardown
    `rm -rf tmp`
  end

  def test_run_command_in_param
    bash.bash(self, 'touch tmp/create_file_test.txt', print: Print.new(true))
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_run_command_in_block
    bash.bash(self, print: Print.new(true)) {'touch tmp/create_file_test.txt'}
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_from
    bash.bash(self, 'touch create_file_test.txt', from: "tmp", print: Print.new(true))
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_output
    assert bash.bash(self, 'ls', print: Print.new(true)).include?('test')
  end

  def test_capture_errors
    assert bash.bash(self, 'rm unknown.file', print: Print.new(true)).include?('No such file or directory')
  end

  def test_stop_run_rest_on_error
    bash.bash(self, print: Print.new(true)) do
      '
      rm unknown.file
      touch tmp/never-create.txt
      '
    end
    assert !bash.bash(self, 'ls tmp', print: Print.new(true)).include?('never-create.txt')
  end

  def test_call_method
    bash.bash(self, ':touch_file_a', print: Print.new(true))
    assert `ls tmp`.include?("file_a")
  end

  def test_call_method_failed
    bash.bash(self, print: Print.new(true), from: "tmp") do
      '
      :return_false
      touch file_b
      '
    end
    assert !`ls tmp`.include?("file_b")
  end

  def test_return_minimise_empty_lines
    assert_equal "a", bash.bash(self, '
      echo ""
      echo "a"
    ', print: Print.new(true))
  end

  def test_inline_method
    assert bash.bash(self, '#{inline_method}', print: Print.new(true)).include?("test")
  end

  private
  def bash
    Bash.new
  end

  def touch_file_a
    bash.bash(self, 'touch file_a', from: "tmp", print: Print.new(true))
  end

  def return_false
    false
  end

  def inline_method
    "ls"
  end
end
