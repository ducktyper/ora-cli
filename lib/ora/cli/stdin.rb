module Ora::Cli
  class Stdin
    def initialize(inputs = [])
      @inputs = inputs
    end

    def gets
      @inputs.pop || STDIN.gets.chomp.strip
    end
  end
end
