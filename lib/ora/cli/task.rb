require "ora/cli/bash.rb"
require "ora/cli/print.rb"
require "ora/cli/stdin.rb"

module Ora::Cli
  class Task
    attr_reader :branch, :stdin, :print

    def initialize(from, inputs: [], print: Print.new)
      @from   = from
      @bash   = Bash.new(self, from: @from, print: print)
      @branch = current_branch
      @stdin  = Stdin.new(bash: @bash, print: print, inputs: inputs)
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

    def feature_branch!
      if %w{master develop staging uat}.include?(branch)
        @print.red "Please checkout feature branch first!"
        false
      end
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
