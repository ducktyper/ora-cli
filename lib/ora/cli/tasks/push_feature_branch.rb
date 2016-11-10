require 'ora/cli/task'

module Ora::Cli
  class PushFeatureBranch < Task
    def commands
      '
      :feature_branch!
      :clean_branch!
      :pull_branch
      git checkout #{develop_branch}
      git pull origin #{develop_branch}
      git checkout #{branch}
      git merge #{develop_branch}
      git push origin #{branch}
      '
    end
  end
end
