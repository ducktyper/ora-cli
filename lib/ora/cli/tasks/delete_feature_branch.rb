require 'ora/cli/task'

module Ora::Cli
  class DeleteFeatureBranct < Task
    def commands
      '
      :feature_branch!
      :clean_branch!
      git checkout #{develop_branch}
      git branch -D #{branch}
      git push origin :#{branch} || true
      '
    end
  end
end
