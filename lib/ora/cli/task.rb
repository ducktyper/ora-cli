require 'ora/cli/print'
require 'ora/cli/bash'
require 'ora/cli/stdin'

module Ora::Cli
  class Task
    attr_reader :branch, :inputs, :print

    def initialize(from, inputs: [], print: Print.new)
      @from   = from
      @bash   = Bash.new(self, from: @from, print: print)
      @branch = current_branch
      @inputs = inputs
      @print  = print
    end

    def run
      @bash.run commands
    end

    def commands
      raise "Override this method in subclass"
    end

    private
    def current_branch
      @bash.silent('git branch | grep \\*').sub("*", "").strip
    end

    def clean_branch!
      if dirty?
        print.red "Please clean the feature branch '#{branch}'!"
        return false
      end
    end
    def dirty?
      !@bash.silent('git status').include? 'nothing to commit'
    end
  end
end
