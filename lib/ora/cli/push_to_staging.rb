require 'ora/cli/print'

module Ora::Cli
  class PushToStaging
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
        git checkout staging
        git merge #{@branch}
        git push origin staging
        git checkout #{@branch}
        "
      end
    end

    private
    def current_branch
      bash(from: @from, silent: true) {"git branch | grep \\*"}.sub("*", "").strip
    end

    def dirty?
      !bash(from: @from, silent: true) {"git status"}.include? 'nothing to commit'
    end
  end
end
