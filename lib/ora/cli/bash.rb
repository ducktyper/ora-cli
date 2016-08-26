require 'ora/cli/print'

module Ora::Cli
  module Bash
    include Print

    def bash(commands = nil, from: nil, silent: false)
      success = true
      (block_given? ? yield : commands).split("\n").map(&:strip).reject(&:empty?).map do |command|
        output = ''
        if success
          puts_green command unless silent
          if command.start_with? ":"
            unless (success = (method(command.sub(':', '')).call != false))
              unless silent
                puts_red "Process Failed! Please resolve the issue above and run commands below manually\n"
                puts_red command
              end
            end
          else
            move        = "cd #{from} && " if from
            capture_err = " 2>&1"
            raw_command = command.gsub(/#\{([\S]+)\}/) do
              method(Regexp.last_match[1]).call
            end
            output = `#{move}#{raw_command}#{capture_err}`
            puts_plain output unless silent
            unless (success = $?.success?)
              unless silent
                puts_red "Process Failed! Please resolve the issue above and run commands below manually\n"
                puts_red command
              end
            end
          end
        else
          puts_red command unless silent
        end
        output
      end.map(&:strip).reject(&:empty?).join("\n")
    end
  end
end
