module Ora::Cli
  module Bash
    def bash(from: nil, silent: false)
      yield.split("\n").map(&:strip).reject(&:empty?).map do |command|
        move   = "cd #{from} && " if from
        output = `#{move}#{command}`
        puts output unless silent
        output
      end.join("\n")
    end
  end
end
