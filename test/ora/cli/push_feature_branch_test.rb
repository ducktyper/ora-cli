require 'test_helper'
require 'ora/cli/tasks/push_feature_branch'

class PushFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
    `rm #{Ora::Cli::Task::CONTINUE_FILE}`
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

  def test_conflict_save_unprocess_commands
    commit_remote_branch(:feature, "conflict.rb")
    bash_repo('
      touch conflict.rb
      echo "aaa" > conflict.rb
      git add -A
      git commit -m "add conflict.rb"
    ')
    subject.run

    continue_hash = JSON.parse(`cat #{Ora::Cli::Task::CONTINUE_FILE}`)
    assert_equal ["git push origin feature"], continue_hash['commands']
    assert_equal 'push_feature_branch', continue_hash['task']
    assert_equal(
      {"from"=>"tmp/repository", "branch"=>"feature"},
      continue_hash['variables']
    )
  end

  private
  def subject
    PushFeatureBranch.new(REPOSITORY, print: Print.new(true))
  end

  def work_on_feature_branch
    bash_repo('git checkout -b feature')
    commit_branch(:feature, "test.txt")
  end

  def current_branch
    bash_repo('git branch | grep \\*').sub("*", "").strip
  end
end
