require "ora/cli/print.rb"

module Ora::Cli
  class Stdin
    def initialize(bash:, print: Print.new, inputs: [])
      @bash   = bash
      @print  = print
      @inputs = inputs
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
