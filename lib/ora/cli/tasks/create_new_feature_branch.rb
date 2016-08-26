require 'ora/cli/task'

module Ora::Cli
  class CreateNewFeatureBranch < Task
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
      @branch_name = Stdin.new(inputs).gets
    end
  end
end