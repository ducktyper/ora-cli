require 'test_helper'
require 'ora/cli/tasks/switch_branch'

class SwitchBranchTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_switch_branch
    subject.run
    assert_equal "feature1", current_branch
  end

  def test_stash_save
    subject.run
    assert_equal "stash@{0}: On feature2: OraCli",
      bash_repo('git stash list')
  end

  def test_stash_pop
    subject(inputs: ['feature1']).run
    subject(inputs: ['feature2']).run
    assert bash_repo('git stash list').empty?
    assert bash_repo('ls').include? "untracted_file.txt"
  end

  def test_only_feature_branch_can_be_dirty
    dirty_branch(:develop, "untracted_file.txt")
    assert_raises { subject(inputs: ['feature1']).run }
  end

  def test_no_dirty
    bash_repo('rm untracted_file.txt')
    subject(inputs: ['feature1']).tap do |obj|
      obj.run
      assert_equal true, obj.success?
    end
    subject(inputs: ['feature2']).tap do |obj|
      obj.run
      assert_equal true, obj.success?
    end
  end

  private
  def subject(inputs: ['feature1'])
    SwitchBranch.new(REPOSITORY, print: Print.new(true), inputs: inputs)
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature1')
    bash_repo('git checkout -b feature2')
    bash_repo('touch untracted_file.txt')
  end

  def current_branch
    bash_repo('git branch | grep \\*').sub("*", "").strip
  end
end
