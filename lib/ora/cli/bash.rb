require 'ora/cli/print'

module Ora::Cli
  module Bash
    include Print

    def bash(from: nil, silent: false)
      success = true
      yield.split("\n").map(&:strip).reject(&:empty?).map do |command|
        output = ''
        if success
          puts_green command unless silent
          move        = "cd #{from} && " if from
          capture_err = " 2>&1"
          output = `#{move}#{command}#{capture_err}`
          puts output unless silent
          unless (success = $?.success?)
            puts_red "Process Failed! Please resolve the issue above and run commands below manually\n"
            puts_red command
          end
        else
          puts_red command unless silent
        end
        output
      end.join("\n")
    end
  end
end
