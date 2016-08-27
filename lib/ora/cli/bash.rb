module Ora::Cli
  class Bash
    def initialize(target, from: nil, print: Print.new)
      @target = target
      @from   = from
      @print  = print
    end

    def silent command
      `#{move}#{command}#{capture_err}`
    end

    def run commands
      can_continue = true
      extract_commands(commands).map do |unprocessed_command|
        command = complete_command(unprocessed_command)
        can_continue ? @print.green(command) : @print.red(command)

        next unless can_continue

        output, can_continue = run_command(command)
        show_failed_message(command) unless can_continue
        output
      end.compact.map(&:strip).reject(&:empty?).join("\n")
    end

    private
    def move
      "cd #{@from} && " if @from
    end
    def capture_err
      " 2>&1"
    end

    def extract_commands text
      text.split("\n").map(&:strip).reject(&:empty?)
    end
    def join_outputs outputs
      outputs.compact.map(&:strip).reject(&:empty?).join("\n")
    end

    def target_call method_name
      @target.method(method_name).call
    end

    def complete_command unprocessed_command
      unprocessed_command.gsub(/#\{([\S]+)\}/) do
        target_call Regexp.last_match[1]
      end
    end

    def run_command command
      if run_method? command
        [nil, run_method(command)]
      else
        [run_shell(command), $?.success?]
      end
    end
    def run_method? command
      command.start_with? ":"
    end
    def run_method_name command
      command.sub(':', '')
    end
    def run_method command
       run_method_success? target_call(run_method_name(command))
    end
    def run_method_success? method_return
      method_return != false
    end
    def run_shell command
      output = `#{move}#{command}#{capture_err}`
      @print.plain output
      output
    end

    def show_failed_message command
      @print.red "Process Failed! Please resolve the issue above and run commands below manually\n"
      @print.red command
    end
  end
end
