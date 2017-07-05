require 'test_helper'
require 'ora/cli/tasks/push_feature_branch'

class PushFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_push_feature_branch
    subject.run
    assert bash_repo('git push origin feature').include? "up-to-date"
  end

  def test_stay_on_feature_branch
    subject.run
    assert_equal "feature", current_branch
  end

  def test_pull_feature_branch
    commit_remote_branch(:feature, "remote_file.txt")
    subject.run
    assert bash_repo('ls').include? "remote_file.txt"
  end

  def test_merge_latest_develop
    commit_remote_branch(:develop, "remote_file.txt")
    checkout :feature
    subject.run
    assert bash_repo('ls').include? "remote_file.txt"
  end

  def test_stop_on_none_feature_branch
    bash_repo('git checkout develop')
    assert subject.run.include? "Precondition not met!"
  end

  def test_stop_on_dirty_branch
    dirty_branch(:feature, "dirty.rb")
    assert subject.run.include? "Precondition not met!"
  end

  def test_show_unprocess_commands_on_fail
    commit_remote_branch(:feature, "conflict.rb", "from_remote")
    commit_branch(:feature, "conflict.rb", "from_local")
    subject.run.include? "Failed commands:\ngit pull origin feature"
  end

  def test_custom_develop_branch
    bash_repo("git checkout -b sprint01")
    commit_remote_branch(:sprint01, "sprint01.rb", "from_remote")

    checkout('feature')
    subject(develop_branch: "sprint01").run
    assert_equal "feature", current_branch
    assert bash_repo('ls').include? "sprint01.rb"
  end

  private
  def subject(develop_branch: nil)
    PushFeatureBranch.new(REPOSITORY, print: Print.new(true),
                         develop_branch: develop_branch)
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:feature, "test.txt")
  end
end
