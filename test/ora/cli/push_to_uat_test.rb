require 'test_helper'

class PushToUatTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_merge_to_uat
    subject.run
    checkout(:uat)
    assert bash_repo('ls').include? "test.txt"
  end

  def test_push_to_uat
    subject.run
    checkout(:uat)
    assert bash_repo('git push origin uat').include? "up-to-date"
  end

  def test_stay_on_feature_branch
    subject.run
    assert_equal "feature", current_branch
  end

  def test_pull_origin_uat
    commit_remote_branch(:uat, "remote_file.txt")
    subject.run
    assert bash_repo('ls').include? "remote_file.txt"
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
    PushToUat.new(REPOSITORY, print: Print.new(true))
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:feature, "test.txt")
  end

  def current_branch
    bash_repo('git branch | grep \\*').sub("*", "").strip
  end
end