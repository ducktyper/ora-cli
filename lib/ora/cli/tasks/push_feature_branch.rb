module Ora::Cli
  class PushFeatureBranch < Task
    def commands
      '
      :feature_branch!
      :clean_branch!
      git checkout develop
      git pull origin develop
      git checkout #{branch}
      git merge develop
      git push origin #{branch}
      '
    end
  end
end
