module Ora::Cli
  class Bash
    def initialize(target, from: nil)
      @target = target
      @from   = from
    end

    def bash(commands = nil, print: Print.new)
      success = true
      (commands || yield).split("\n").map(&:strip).reject(&:empty?).map do |unprocessed_command|
        output = ''
        command = unprocessed_command.gsub(/#\{([\S]+)\}/) do
          @target.method(Regexp.last_match[1]).call
        end

        if success
          print.green command
          if command.start_with? ":"
            unless (success = (@target.method(command.sub(':', '')).call != false))
              print.red "Process Failed! Please resolve the issue above and run commands below manually\n"
              print.red command
            end
          else
            move        = "cd #{@from} && " if @from
            capture_err = " 2>&1"
            output = `#{move}#{command}#{capture_err}`
            print.plain output
            unless (success = $?.success?)
              print.red "Process Failed! Please resolve the issue above and run commands below manually\n"
              print.red command
            end
          end
        else
          print.red command
        end
        output
      end.map(&:strip).reject(&:empty?).join("\n")
    end
  end
end
