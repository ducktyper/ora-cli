require 'test_helper'
require 'ora/cli/tasks/push_to_master'

class PushToMasterTest < Minitest::Test
  def setup
    reset_tmp
    set_versions
    work_on_feature_branch
    accept_pull_request
  end
  def teardown
    delete_tmp
  end

  def test_stash_save_and_pop
    bash_repo('git checkout -b feature2')
    dirty_branch(:feature2, "dirty.rb")
    subject.run
    assert bash_repo('ls').include? "dirty.rb"
  end

  def test_push_develop
    subject.run
    checkout(:develop)
    assert bash_repo('git push origin develop').include? "up-to-date"
  end

  def test_merge_to_master
    subject.run
    checkout(:master)
    assert bash_repo('ls').include? "test.txt"
  end

  def test_push_master
    subject.run
    checkout(:master)
    assert bash_repo('git push origin master').include? "up-to-date"
  end

  def test_stay_on_feature_branch
    subject.run
    assert_equal "feature", current_branch
  end

  def test_stop_on_dirty_main_branch
    dirty_branch(:develop, "dirty.rb")
    assert subject.run.include? "Precondition not met!"
  end

  def test_push_new_version_by_incresing_build_number
    subject.run
    assert remote_tags.include? "v0.0.0.2"
  end

  def test_messages
    subject.run
    assert bash_repo("git show v0.0.0.2").include? "1 feature"
  end

  def test_messages_for_multiple_pull_requests
    commit_branch(:feature, "test3")
    accept_pull_request(2)
    subject.run
    assert bash_repo("git show v0.0.0.2").include? "2 feature\n1 feature"
  end

  def test_no_tag_on_no_new_pull_request
    subject.run
    commit_branch(:feature, "test3")
    accept_pull_request('no_pull_request')
    subject.run
    assert_equal false, bash_repo("git tag").include?("v0.0.0.3")
  end

  def test_custom_version
    subject(['v1.1.1.1']).run
    assert remote_tags.include? "v1.1.1.1"
  end

  def test_validate_version
    subject(['v1.1.1', 'invalid', 'v1.1.1.1']).run
    assert remote_tags.include? "v1.1.1.1"
  end

  private
  def subject(inputs = [''])
    PushToMaster.new(REPOSITORY, inputs: inputs, print: Print.new(true))
  end

  def accept_pull_request(pull_request = 1)
    bash_repo("
      git checkout develop
      git merge feature -m 'Merge pull request ##{pull_request} from feature'
      git checkout feature
    ")
    bash_repo('git log')
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:develop, "test2.txt")
    commit_branch(:feature, "test.txt")
  end

  def set_versions
    bash_repo('
      git checkout master
      git tag -a "v0.0.0.1" -m "first version"
      git push --tags
      git checkout develop
    ')
  end

  def remote_tags
    bash_repo('
      git checkout master
      git tag | xargs git tag -d
      git fetch --tags
    ')
    bash_repo('git tag')
  end
end
