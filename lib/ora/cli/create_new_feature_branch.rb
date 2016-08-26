require 'ora/cli/task'

module Ora::Cli
  class CreateNewFeatureBranch < Task
    attr_reader :branch_name

    def run
      bash(from: @from, silent: @silent) do
        '
        :set_branch_name
        :clean_branch!
        git checkout develop
        git pull origin develop
        git checkout -b #{branch_name}
        '
      end
    end

    private
    def clean_branch!
      if dirty?
        puts_red "Please clean the feature branch '#{@branch}'!"
        return false
      end
    end
    def dirty?
      !bash('git status', from: @from, silent: true).include? 'nothing to commit'
    end

    def set_branch_name
      @branch_name = Stdin.new(inputs).gets
    end
  end
end
