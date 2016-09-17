require 'ora/cli/task'

module Ora::Cli
  class PushToAus < Task

    def commands
      '
      :feature_branch!
      :clean_branch!
      git checkout develop
      git pull origin develop
      git checkout #{branch}
      git merge develop
      git checkout aus
      git pull origin aus
      git merge #{branch}
      git push origin aus
      git checkout #{branch}
      :slack_message_to_paste
      '
    end

    private
    def slack_message_to_paste
      print.plain ":merge: #{branch} => aus\n:monorail: aus"
      ''
    end
  end
end
