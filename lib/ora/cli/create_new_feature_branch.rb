require 'ora/cli/print'

module Ora::Cli
  class CreateNewFeatureBranch
    include Print

    def initialize(from, silent: false)
      @from   = from
      @silent = silent
    end
    def run(inputs = [])
      branch_name = Stdin.new(inputs).gets

      bash(from: @from, silent: @silent) do
        "
        :clean_branch!
        git checkout develop
        git pull origin develop
        git checkout -b #{branch_name}
        "
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
      !bash("git status", from: @from, silent: true).include? 'nothing to commit'
    end
  end
end
