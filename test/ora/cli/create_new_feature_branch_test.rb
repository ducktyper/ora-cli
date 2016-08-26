require 'test_helper'

class CreateNewFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
  end
  def teardown
    delete_tmp
  end

  def test_run_method_defined
    subject.run(["new_feature"])
    assert bash_repo('git status').include? "new_feature"
  end

  def test_start_from_develop_branch
    commit_branch(:develop, "develop.rb")
    checkout(:master)
    subject.run(["new_feature"])
    assert bash_repo('ls').include? "develop.rb"
  end

  def test_pull_develop_branch
    commit_remote_branch(:develop, "develop.rb")
    subject.run(["new_feature"])
    checkout(:develop)
    assert bash_repo('ls').include? "develop.rb"
  end

  def test_stop_on_dirty_branch
    dirty_branch(:develop, "dirty.rb")
    assert subject.run(["new_feature"]).empty?
  end

  private
  def subject
    CreateNewFeatureBranch.new(REPOSITORY, silent: true)
  end
end
