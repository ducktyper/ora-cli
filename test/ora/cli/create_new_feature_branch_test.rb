require 'test_helper'

class CreateNewFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
  end
  def teardown
    delete_tmp
  end

  def test_run_method_defined
    CreateNewFeatureBranch.new.run(["new_feature"])
    bash(from: REPOSITORY, "git status").include? "new_feature"
  end
end
