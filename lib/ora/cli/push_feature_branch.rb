require 'ora/cli/print'

module Ora::Cli
  class PushFeatureBranch
    include Print

    def initialize(from, silent: false)
      @from   = from
      @silent = silent
      @branch = current_branch
    end
    def run(inputs = [])
      if dirty?
        puts_red "Please clean repo!"
        return "ERROR"
      end

      bash(from: @from, silent: @silent) do
        "
        git checkout develop
        git pull origin develop
        git checkout #{@branch}
        git merge develop
        git push origin #{@branch}
        "
      end
    end

    private
    def current_branch
      bash("git branch | grep \\*", from: @from, silent: true).sub("*", "").strip
    end

    def dirty?
      !bash("git status", from: @from, silent: true).include? 'nothing to commit'
    end
  end
end
