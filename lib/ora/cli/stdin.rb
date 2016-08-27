module Ora::Cli
  class Stdin
    def initialize(inputs = [], print: Print.new)
      @inputs = inputs
      @print  = print
    end

    def gets(pattern = '')
      input = nil

      until input
        input = @inputs.shift || STDIN.gets.chomp.strip
        unless input.match(pattern)
          @print.red "Please match #{pattern.inspect}"
          input = nil
        end
      end

      input
    end
  end
end
