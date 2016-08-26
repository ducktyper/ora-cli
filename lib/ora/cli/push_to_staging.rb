require 'ora/cli/task'

module Ora::Cli
  class PushToStaging < Task
    def run
      bash(from: @from, silent: @silent) do
        '
        :clean_branch!
        git checkout develop
        git pull origin develop
        git checkout #{branch}
        git merge develop
        git checkout staging
        git pull origin staging
        git merge #{branch}
        git push origin staging
        git checkout #{branch}
        :show_slack_message
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

    def show_slack_message
      puts_green "Paste below to slack"
      puts ":merge: #{branch} => staging\n:monorail: staging"
    end
  end
end
