require 'ora/cli/print'

module Ora::Cli
  class Task
    include Print

    attr_reader :branch, :inputs

    def initialize(from, silent: false, inputs: [])
      @from   = from
      @silent = silent
      @branch = current_branch
      @inputs = inputs
    end

    def run
      raise 'Please override it in subclass!'
    end

    private
    def current_branch
      bash('git branch | grep \\*', from: @from, silent: true).sub("*", "").strip
    end
  end
end
