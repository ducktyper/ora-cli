require 'test_helper'
require 'ora/cli/tasks/push_to_aus'

class PushToAusTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_merge_to_aus
    subject.run
    checkout(:aus)
    assert bash_repo('ls').include? "test.txt"
  end

  def test_push_to_aus
    subject.run
    checkout(:aus)
    assert bash_repo('git push origin aus').include? "up-to-date"
  end

  def test_stay_on_feature_branch
    subject.run
    assert_equal "feature", current_branch
  end

  def test_pull_origin_aus
    commit_remote_branch(:aus, "remote_file.txt")
    checkout :feature
    subject.run
    checkout :aus
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
    assert_raises { subject.run }
  end

  def test_stop_on_dirty_branch
    dirty_branch(:feature, "dirty.rb")
    assert_raises { subject.run }
  end

  private
  def subject
    PushToAus.new(REPOSITORY, print: Print.new(true))
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:feature, "test.txt")
  end

  def current_branch
    bash_repo('git branch | grep \\*').sub("*", "").strip
  end
end
