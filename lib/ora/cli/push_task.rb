require 'ora/cli/task'

module Ora::Cli
  class PushTask < Task

    def commands
      '
      :feature_branch!
      :clean_branch!
      git checkout develop
      git pull origin develop
      git checkout #{branch}
      git merge develop
      git checkout #{target}
      git pull origin #{target}
      git merge #{branch}
      git push origin #{target}
      git checkout #{branch}
      :slack_message_to_paste
      '
    end

    private
    def slack_message_to_paste
      print.plain ":merge: #{branch} => #{target}\n:monorail: #{target}"
      ''
    end

    def target
      self.class.name.match(/PushTo(.*)/)[1].downcase
    end
  end
end
