module Ora::Cli
  class CreateNewFeatureBranch
    def initialize(from, silent: false)
      @from   = from
      @silent = silent
    end
    def run(inputs = [])
      branch_name = Stdin.new(inputs).gets

      bash(from: @from, silent: @silent) do
        "
        git checkout develop
        git pull origin develop
        git checkout -b #{branch_name}
        "
      end
    end
  end
end
