require 'test_helper'

class BashTest < Minitest::Test
  include Bash

  def setup
    `rm -rf tmp && mkdir tmp`
  end

  def teardown
    `rm -rf tmp`
  end

  # def test_run_command_in_param
  #   bash("touch tmp/create_file_test.txt", silent: true)
  #   assert `ls tmp`.include? "create_file_test.txt"
  # end

  # def test_run_command_in_block
  #   bash(silent: true) {"touch tmp/create_file_test.txt"}
  #   assert `ls tmp`.include? "create_file_test.txt"
  # end

  # def test_from
  #   bash("touch create_file_test.txt", from: "tmp", silent: true)
  #   assert `ls tmp`.include? "create_file_test.txt"
  # end

  # def test_output
  #   assert bash("ls", silent: true).include?('test')
  # end

  # def test_capture_errors
  #   assert bash("rm unknown.file", silent: true).include?('No such file or directory')
  # end

  # def test_stop_run_rest_on_error
  #   bash(silent: true) do
  #     "
  #     rm unknown.file
  #     touch tmp/never-create.txt
  #     "
  #   end
  #   assert !bash("ls tmp", silent: true).include?('never-create.txt')
  # end

  # def test_call_method
  #   bash(":touch_file_a", silent: true)
  #   assert `ls tmp`.include?("file_a")
  # end

  def test_call_method_failed
    bash(silent: true, from: "tmp") do
      "
      :return_false
      touch file_b
      "
    end
    assert !`ls tmp`.include?("file_b")
  end

  private
  def touch_file_a
    bash("touch file_a", from: "tmp", silent: true)
  end

  def return_false
    false
  end
end
