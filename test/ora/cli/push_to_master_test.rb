require 'test_helper'

class PushToMasterTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
  end

  def test_merge_to_develop
    subject.run
    checkout(:develop)
    assert bash_repo("ls").include? "test.txt"
  end

  def test_push_develop
    subject.run
    checkout(:develop)
    assert bash_repo("git push origin develop").include? "up-to-date"
  end

  def test_merge_to_master
    subject.run
    checkout(:master)
    assert bash_repo("ls").include? "test.txt"
  end

  def test_push_master
    subject.run
    checkout(:master)
    assert bash_repo("git push origin master").include? "up-to-date"
  end

  def test_stay_on_feature_branch
    subject.run
    assert_equal "feature", current_branch
  end

  def test_error_on_dirty_branch
    dirty_branch(:feature, "dirty.rb")
    assert subject.run.include? "ERROR"
  end

  private
  def subject
    PushToMaster.new(REPOSITORY, silent: true)
  end

  def work_on_feature_branch
    bash_repo("git checkout -b feature")
    commit_branch(:feature, "test.txt")
  end

  def current_branch
    bash_repo("git branch | grep \\*").sub("*", "").strip
  end
end
