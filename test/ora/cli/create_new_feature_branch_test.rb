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
end
