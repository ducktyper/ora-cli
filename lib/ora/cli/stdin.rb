module Ora::Cli
  class Stdin
    def initialize(inputs = [], print: Print.new)
      @inputs = inputs
      @print  = print
    end

    def gets(pattern = '')
      input   = nil
      success = false

      until success
        input = @inputs.pop || STDIN.gets.chomp.strip
        if input.match(pattern)
          success = true
        else
          @print.puts_red "Please match #{pattern.inspect}"
        end
      end

      input
    end
  end
end
