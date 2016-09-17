require "ora/cli/bash"
require "ora/cli/print"
require "ora/cli/stdin"

module Ora::Cli
  class Task
    attr_reader :branch, :stdin, :print

    MAIN_BRANCHES = %w{master develop staging uat aus}

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

    def success?
      @bash.success?
    end

    private
    def current_branch
      @bash.silent('git branch | grep \\*').sub("*", "").strip
    end

    def main_branch?
      MAIN_BRANCHES.include? branch
    end

    def feature_branch!
      if main_branch?
        @print.red "Please checkout feature branch first!"
        raise __method__
      end
      ''
    end

    def clean_branch!
      if dirty?
        print.red "Please clean the feature branch '#{branch}'!"
        raise __method__
      end
      ''
    end
    def dirty?
      !@bash.silent('git status').include? 'nothing to commit'
    end
  end
end
