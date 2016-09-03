require "ora/cli/print.rb"

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
      unprocessed_commands = extract commands

      outputs = []
      while (command = complete unprocessed_commands.shift)
        next if command.empty?
        break unless call command do |output|
          outputs.push output
        end
      end

      handle_failed unprocessed_commands

      join outputs
    end

    def select command
      `#{move}#{command} | #{selecta}`
    end

    private
    def move
      "cd #{@from} && " if @from
    end
    def capture_err
      " 2>&1"
    end

    def extract commands
      commands.split("\n").map(&:strip).reject(&:empty?)
    end
    def join outputs
      outputs.compact.map(&:strip).reject(&:empty?).join("\n")
    end

    def call_target method_name
      @target.method(method_name).call
    end

    def complete unprocessed_command
      return nil unless unprocessed_command

      unprocessed_command.gsub(/#\{([\S]+)\}/) do
        call_target Regexp.last_match[1]
      end
    end

    def call command
      @print.green command

      success =
        if method? command
          call_method command
        else
          yield(shell command)
          $?.success?
        end

      alert command unless success
      success
    end
    def method? command
      command.start_with? ":"
    end
    def method_name command
      command.sub(':', '')
    end
    def call_method command
       success_call? call_target(method_name command)
    end
    def success_call? method_return
      method_return != false
    end
    def shell command
      @print.plain `#{move}#{command}#{capture_err}`
    end

    def alert command
      @print.red "\nProcess Failed! Please resolve the issue above and run commands below manually\n"
      @print.red command
    end

    def handle_failed unprocessed_commands
      unprocessed_commands.each do |unprocessed_command|
        @print.red(complete unprocessed_command)
      end
    end

    def selecta
      @selecta ||= File.expand_path('../../../../bin/ora_selecta', __FILE__)
    end
  end
end
