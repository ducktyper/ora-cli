require 'ora/cli/print'

module Ora::Cli
  module Bash
    include Print

    def bash(from: nil, silent: false)
      yield.split("\n").map(&:strip).reject(&:empty?).map do |command|
        puts_green command unless silent
        move   = "cd #{from} && " if from
        output = `#{move}#{command}`
        puts output unless silent
        output
      end.join("\n")
    end
  end
end
