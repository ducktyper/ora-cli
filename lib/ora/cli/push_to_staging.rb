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
      bash(from: @from, silent: @silent) do
        "
        git checkout staging
        git merge #{@branch}
        "
      end
    end

    private
    def current_branch
      bash(from: @from, silent: true) {"git branch | grep \\*"}.sub("*", "").strip
    end
  end
end