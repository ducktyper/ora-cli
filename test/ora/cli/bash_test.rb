require 'test_helper'

class BashTest < Minitest::Test
  def setup
    `rm -rf tmp && mkdir tmp`
  end

  def teardown
    `rm -rf tmp`
  end

  def test_run_command_in_param
    bash.run('touch create_file_test.txt')
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_output
    assert bash.run('pwd').include?('tmp')
  end

  def test_silent
    assert bash.silent('pwd').include?('tmp')
  end

  def test_capture_errors
    assert bash.run('rm unknown.file').include?('No such file or directory')
  end

  def test_stop_run_rest_on_error
    bash.run '
      rm unknown.file
      touch never-create.txt
    '
    assert !bash.run('ls').include?('never-create.txt')
  end

  def test_call_method
    bash.run(':touch_file_a')
    assert `ls tmp`.include?("file_a")
  end

  def test_call_method_failed
    bash.run '
      :return_false
      touch file_b
    '
    assert !`ls tmp`.include?("file_b")
  end

  def test_return_minimise_empty_lines
    assert_equal "a", bash.run('
      echo ""
      echo "a"
    ')
  end

  def test_inline_method
    assert bash.run('#{inline_method}').include?("tmp")
  end

  private
  def bash
    Bash.new(self, from: "tmp", print: Print.new(true))
  end

  def touch_file_a
    bash.run('touch file_a')
  end

  def return_false
    false
  end

  def inline_method
    "pwd"
  end
end
