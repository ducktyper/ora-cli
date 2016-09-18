require "ora/cli/print"
require "ora/cli/path"

module Ora::Cli
  class Bash
    attr_reader :unprocessed_commands

    def initialize(target, from: nil, print: Print.new)
      @target               = target
      @from                 = from
      @print                = print
      @success              = true
      @unprocessed_commands = []
    end

    def silent command
      `#{move}#{command}#{capture_err}`
    end

    def run commands
      @success = true
      @unprocessed_commands = extract commands

      outputs = []
      command = ''
      while (command = complete @unprocessed_commands.shift)
        next if command.empty?

        if method? command
          sub_commands = call_method command
          @unprocessed_commands.unshift(*extract(sub_commands))
        else
          @success, output = shell command
          outputs.push output
          break unless @success
        end
      end

      @unprocessed_commands.unshift(command) unless @success

      join outputs
    end

    def select command
      `#{move}#{command} | #{Path.selecta}`.strip
    end

    def success?
      @success
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

    def call_target method_name, args = []
      @target.method(method_name).call(*args)
    end

    def complete unprocessed_command
      return nil unless unprocessed_command

      unprocessed_command.gsub(/#\{([\S]+)\}/) do
        call_target Regexp.last_match[1]
      end
    end

    def shell command
      @print.green command

      output  = @print.plain `#{move}#{command}#{capture_err}`
      success = $?.success?

      show_failed_message unless success

      [success, output]
    end
    def method? command
      command.start_with? ":"
    end
    def call_method command
      list   = command.split
      method = list.shift.sub(':', '')
      args   = list.join.split(',').map(&:strip)
      call_target(method, args)
    end

    def show_failed_message
      @print.red "\nProcess Failed! Please resolve the issue above run 'ora' again to continue\n"
    end

  end
end
