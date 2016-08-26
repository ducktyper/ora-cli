require 'ora/cli/task'

module Ora::Cli
  class PushFeatureBranch < Task
    def run
      bash(from: @from, silent: @silent) do
        '
        :clean_branch!
        git checkout develop
        git pull origin develop
        git checkout #{branch}
        git merge develop
        git push origin #{branch}
        '
      end
    end

    private
    def clean_branch!
      if dirty?
        puts_red "Please clean the feature branch '#{branch}'!"
        return false
      end
    end
    def dirty?
      !bash('git status', from: @from, silent: true).include? 'nothing to commit'
    end
  end
end
