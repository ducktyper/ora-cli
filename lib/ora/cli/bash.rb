module Ora::Cli
  class Bash
    def bash(target, commands = nil, from: nil, print: Print.new)
      success = true
      (block_given? ? yield : commands).split("\n").map(&:strip).reject(&:empty?).map do |unprocessed_command|
        output = ''
        command = unprocessed_command.gsub(/#\{([\S]+)\}/) do
          target.method(Regexp.last_match[1]).call
        end

        if success
          print.puts_green command
          if command.start_with? ":"
            unless (success = (target.method(command.sub(':', '')).call != false))
              print.puts_red "Process Failed! Please resolve the issue above and run commands below manually\n"
              print.puts_red command
            end
          else
            move        = "cd #{from} && " if from
            capture_err = " 2>&1"
            output = `#{move}#{command}#{capture_err}`
            print.puts_plain output
            unless (success = $?.success?)
              print.puts_red "Process Failed! Please resolve the issue above and run commands below manually\n"
              print.puts_red command
            end
          end
        else
          print.puts_red command
        end
        output
      end.map(&:strip).reject(&:empty?).join("\n")
    end
  end
end
