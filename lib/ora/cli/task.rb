require 'ora/cli/print'
require 'ora/cli/bash'
require 'ora/cli/stdin'

module Ora::Cli
  class Task
    include Bash

    attr_reader :branch, :inputs, :print

    def initialize(from, inputs: [], print: Print.new)
      @from   = from
      @branch = current_branch
      @inputs = inputs
      @print  = print
    end

    def run
      bash(commands, from: @from, print: print)
    end

    def commands
      raise "Override this method in subclass"
    end

    private
    def current_branch
      bash('git branch | grep \\*', from: @from, print: Print.new(true)).sub("*", "").strip
    end

    def clean_branch!
      if dirty?
        print.puts_red "Please clean the feature branch '#{branch}'!"
        return false
      end
    end
    def dirty?
      !bash('git status', from: @from, print: Print.new(true)).include? 'nothing to commit'
    end
  end
end
