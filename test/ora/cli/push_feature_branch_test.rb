require 'test_helper'

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

  def test_merge_latest_develop
    commit_remote_branch(:develop, "remote_file.txt")
    subject.run
    assert bash_repo('ls').include? "remote_file.txt"
  end

  def test_stop_on_dirty_branch
    dirty_branch(:feature, "dirty.rb")
    assert subject.run.empty?
  end

  private
  def subject
    PushFeatureBranch.new(REPOSITORY, silent: true)
  end

  def work_on_feature_branch
    bash_repo("git checkout -b feature")
    commit_branch(:feature, "test.txt")
  end

  def current_branch
    bash_repo("git branch | grep \\*").sub("*", "").strip
  end
end
