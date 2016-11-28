require 'test_helper'
require 'ora/cli/tasks/delete_feature_branch'

class DeleteFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_delete_local_branch
    subject.run
    assert checkout(:feature).include? "error"
  end

  def test_in_develop_branch
    subject.run
    assert_equal "develop", current_branch
  end

  def test_delete_remote_branch
    bash_repo('git push origin feature')
    subject.run
    assert bash_repo('git fetch origin feature').include? "Couldn't find remote"
  end

  def test_ignore_error_on_remote_branch_not_found
    subject.run
    assert subject.success?
  end

  private
  def subject
    @subject ||= DeleteFeatureBranch.new(REPOSITORY, print: Print.new(true))
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:feature, "test.txt")
  end
end
