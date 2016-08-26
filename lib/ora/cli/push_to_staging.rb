require 'ora/cli/task'

module Ora::Cli
  class PushToStaging < Task

    def commands
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

    private
    def show_slack_message
      puts_green "Paste below to slack"
      puts_plain ":merge: #{branch} => staging\n:monorail: staging"
    end
  end
end
