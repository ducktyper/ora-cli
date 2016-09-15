require 'ora/cli/task'

module Ora::Cli
  class NewFeatureBranch < Task
    attr_reader :branch_name

    def commands
      '
      :set_branch_name
      :clean_branch!
      git checkout develop
      git pull origin develop
      git checkout -b #{branch_name}
      '
    end

    private
    def set_branch_name
      print.inline 'Type new branch name: '
      @branch_name = stdin.gets(/^[a-zA-Z0-9\/_-]+$/)
      ''
    end
  end
end
