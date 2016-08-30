require 'ora/cli/task'

module Ora::Cli
  class PushToUat < Task

    def commands
      '
      :feature_branch!
      :clean_branch!
      git checkout develop
      git pull origin develop
      git checkout #{branch}
      git merge develop
      git checkout uat
      git pull origin uat
      git merge #{branch}
      git push origin uat
      git checkout #{branch}
      :slack_message_to_paste
      '
    end

    private
    def slack_message_to_paste
      print.plain ":merge: #{branch} => uat\n:monorail: uat"
    end
  end
end
