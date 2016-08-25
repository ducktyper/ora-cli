require 'ora/cli/print'

module Ora::Cli
  class PushToStaging
    include Print

    def initialize(from, silent: false)
      @from   = from
      @silent = silent
      @branch = current_branch
    end
    def run(inputs = [])
      bash(from: @from, silent: @silent) do
        "
        :clean_branch!
        git checkout develop
        git pull origin develop
        git checkout #{@branch}
        git merge develop
        git checkout staging
        git pull origin staging
        git merge #{@branch}
        git push origin staging
        git checkout #{@branch}
        :show_slack_message
        "
      end
    end

    private
    def current_branch
      bash("git branch | grep \\*", from: @from, silent: true).sub("*", "").strip
    end

    def clean_branch!
      if dirty?
        puts_red "Please clean the feature branch '#{@branch}'!"
        return false
      end
    end
    def dirty?
      !bash("git status", from: @from, silent: true).include? 'nothing to commit'
    end

    def show_slack_message
      puts_green "Paste below to slack"
      puts ":merge: #{@branch} => staging\n:monorail: staging"
    end
  end
end
