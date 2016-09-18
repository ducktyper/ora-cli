require 'test_helper'
require 'ora/cli/tasks/new_feature_branch'

class NewFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
  end
  def teardown
    delete_tmp
  end

  def test_run_method_defined
    subject.run
    assert bash_repo('git status').include? "new_feature"
  end

  def test_start_from_develop_branch
    commit_branch(:develop, "develop.rb")
    checkout(:master)
    subject.run
    assert bash_repo('ls').include? "develop.rb"
  end

  def test_pull_develop_branch
    commit_remote_branch(:develop, "develop.rb")
    subject.run
    checkout(:develop)
    assert bash_repo('ls').include? "develop.rb"
  end

  def test_stop_if_branch_already_exists
    assert subject(["develop"]).run.include? "Precondition not met!"
  end

  def test_stop_on_dirty_branch
    dirty_branch(:develop, "dirty.rb")
    assert subject.run.include? "Precondition not met!"
  end

  def test_branch_name_validation
    subject(["having space", "", "azAZ09/-_"]).run
    assert bash_repo('git status').include? "azAZ09/-_"
  end

  private
  def subject(inputs = ["new_feature"])
    NewFeatureBranch.new(REPOSITORY, inputs: inputs, print: Print.new(true))
  end
end
