module Ora
  module Cli
    class Stdin
      def initialize(inputs = [])
        @inputs = inputs
      end

      def gets
        @inputs.pop || STDIN.get
      end
    end
  end
end
