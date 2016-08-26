require 'ora/cli/print'

module Ora::Cli
  include Print

  class Stdin
    def initialize(inputs = [])
      @inputs = inputs
    end

    def gets(pattern = '')
      input   = nil
      success = false

      until success
        input = @inputs.pop || STDIN.gets.chomp.strip
        if input.match(pattern)
          success = true
        else
          puts_red "Please match #{pattern.inspect}"
        end
      end

      input
    end
  end
end
