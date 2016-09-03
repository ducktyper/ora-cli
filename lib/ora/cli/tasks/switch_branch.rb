require 'ora/cli/task'

module Ora::Cli
  class SwitchBranch < Task
    attr_reader :target_branch

    def commands
      '
      :only_feature_branch_can_be_dirty!
      :switch_to
      git stash save -u "OraCli"
      git checkout #{target_branch}
      #{apply_stash}
      '
    end

    private
    def only_feature_branch_can_be_dirty!
      if main_branch? && dirty?
        print.red "#{branch} branch can't be dirty!"
        return false
      end
    end

    def switch_to
      @target_branch = stdin.select("git branch | grep '^  ' | sed 's/^  //'")
    end

    def apply_stash
      return nil if target_stash_revision.empty?
      "git stash pop #{target_stash_revision}"
    end
    def target_stash_revision
      @target_stash_revision ||=
        @bash.silent("git stash list | grep '#{target_stash_name}' | sed s/:.*//").
          split("\n").first.to_s.strip
    end
    def target_stash_name
      "On #{target_branch}: OraCli"
    end

  end
end
