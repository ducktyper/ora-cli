module Ora
  module Cli
    class CreateNewFeatureBranch
      def initialize(from)
        @from = from
      end
      def run(inputs = [])
        branch_name = Stdin.new(inputs).gets

        bash(from: @from) do
          "git checkout -b #{branch_name}"
        end
      end
    end
  end
end
