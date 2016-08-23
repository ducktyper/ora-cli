require 'test_helper'

class CreateNewFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
  end
  def teardown
    delete_tmp
  end

  def test_run_method_defined
    CreateNewFeatureBranch.new(REPOSITORY, silent: true).run(["new_feature"])
    assert bash_repo("git status").include? "new_feature"
  end

  def test_start_from_develop_branch
    commit_branch(:develop, "develop.rb")
    checkout(:master)
    CreateNewFeatureBranch.new(REPOSITORY, silent: true).run(["new_feature"])
    assert bash_repo("ls").include? "develop.rb"
  end

  def test_pull_develop_branch
    commit_remote_branch(:develop, "develop.rb")
    CreateNewFeatureBranch.new(REPOSITORY, silent: true).run(["new_feature"])
    checkout(:develop)
    assert bash_repo("ls").include? "develop.rb"
  end

  def test_error_on_dirty_branch
    dirty_branch(:develop, "dirty.rb")
    out = CreateNewFeatureBranch.new(REPOSITORY, silent: true).run(["new_feature"])
    assert out.include? "ERROR"
  end
end
