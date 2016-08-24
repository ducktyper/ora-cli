require 'test_helper'

class PushToStagingTest < Minitest::Test
  def setup
    reset_tmp
  end
  def teardown
    delete_tmp
  end

  def test_merge_to_staging
    bash_repo("git checkout -b feature")
    commit_branch(:feature, "test.txt")
    subject.run
    checkout(:staging)
    assert bash_repo("ls").include? "test.txt"
  end

  def test_push_to_staging
    checkout(:staging)
    bash_repo("git checkout -b feature")
    commit_branch(:feature, "test.txt")
    subject.run
    checkout(:staging)
    assert bash_repo('git push origin staging').include? "up-to-date"
  end

  private
  def subject
    PushToStaging.new(REPOSITORY, silent: true)
  end
end
