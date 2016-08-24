require 'test_helper'

class BashTest < Minitest::Test
  include Bash

  def setup
    `rm -rf tmp && mkdir tmp`
  end

  def teardown
    `rm -rf tmp`
  end

  def test_run_command
    bash(silent: true) {"touch tmp/create_file_test.txt"}
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_from
    bash(from: "tmp", silent: true) {"touch create_file_test.txt"}
    assert `ls tmp`.include? "create_file_test.txt"
  end

  def test_output
    assert bash {"ls"}.include?('test')
  end

  def test_capture_errors
    assert bash {"rm unknown.file"}.include?('No such file or directory')
  end

  def test_stop_run_rest_on_error
    bash do
      "
      rm unknown.file
      touch tmp/never-create.txt
      "
    end
    assert !bash {"ls tmp"}.include?('never-create.txt')
  end
end
