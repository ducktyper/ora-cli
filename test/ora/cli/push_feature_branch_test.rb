require 'test_helper'
require 'ora/cli/tasks/push_feature_branch'

class PushFeatureBranchTest < Minitest::Test
  def setup
    reset_tmp
    work_on_feature_branch
  end
  def teardown
    delete_tmp
    bash_repo("rm #{Ora::Cli::Task::CONTINUE_FILE}")
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

  def test_conflict_continue_unprocess_commands
    commit_remote_branch(:feature, "conflict.rb", "from_remote")
    commit_branch(:feature, "conflict.rb", "from_local")
    subject.run

    assert_equal true, File.exist?(File.expand_path(Ora::Cli::Task::CONTINUE_FILE))

    # resolve conflict
    bash_repo('echo "change2" > conflict.rb')
    bash_repo('git add -A && git commit -m "merge"')

    continue_hash = JSON.parse(`cat #{Ora::Cli::Task::CONTINUE_FILE}`)
    subject.continue(continue_hash)

    assert_equal true, remote_upto_date(:feature)
    assert_equal false, File.exist?(File.expand_path(Ora::Cli::Task::CONTINUE_FILE))
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
