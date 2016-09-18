require "ora/cli/bash"
require "ora/cli/print"
require "ora/cli/stdin"
require 'ora/cli/precondition_error'
require "json"

module Ora::Cli
  class Task
    attr_reader :branch, :stdin, :print

    DEVELOP_BRANCH = 'develop'
    CONTINUE_FILE  = '~/.ora_continue'

    def initialize(from, inputs: [], print: Print.new)
      @from   = from
      @bash   = Bash.new(self, from: @from, print: print)
      @branch = current_branch
      @stdin  = Stdin.new(bash: @bash, print: print, inputs: inputs)
      @print  = print
    end

    def run
      @bash.run commands
      save_on_fail
    rescue PreconditionError => e
      @print.red("Precondition not met!\n#{e.message}")
    end

    def continue(info)
      @print.green("Continue task - #{info['task']}")
      set_variables(info['variables'])
      @bash.run info['commands']
      save_on_fail
      File.delete(File.expand_path(CONTINUE_FILE)) if @bash.success?
    end

    def variables
      instance_variables.inject({}) do |hash, attribute|
        value = instance_variable_get(attribute)
        if value.to_s.start_with? '#<'
          hash
        else
          hash.merge!(attribute.to_s.sub('@', '') => value)
        end
      end
    end

    def set_variables data
      data.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def commands
      raise PreconditionError, "Override this method in subclass."
    end

    def success?
      @bash.success?
    end

    private
    def current_branch
      @bash.silent('git branch | grep \\*').sub("*", "").strip
    end

    def main_branch?
      main_branches.include? branch
    end

    def main_branches
      [DEVELOP_BRANCH] +
      Dir.entries(Path.tasks).
        map {|name| name.match(/push_to_(.*)\.rb/)}.compact.
        map {|match| match[1]}
    end

    def feature_branch!
      if main_branch?
        raise PreconditionError, "Please checkout feature branch first."
      end
      ''
    end

    def clean_branch!
      if dirty?
        raise PreconditionError,
          "Please clean the feature branch '#{branch}'."
      end
      ''
    end
    def dirty?
      !@bash.silent('git status').include? 'nothing to commit'
    end

    def pull_branch
      return '' unless remote_branch?

      "git pull origin #{branch}"
    end
    def remote_branch?
      !@bash.silent("git branch -a | grep remotes/origin/#{branch}$").empty?
    end

    def save_on_fail
      return if @bash.success?

      text = JSON.generate(
        'task'      => underscore(self.class.name.split(':').last),
        'variables' => variables,
        'commands'  => @bash.unprocessed_commands.join("\n")
      )
      File.write(File.expand_path(CONTINUE_FILE), text)
    end

    # File activesupport/lib/active_support/inflector/methods.rb
    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub('::'.freeze, '/'.freeze)
      # word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)(#{inflections.acronym_regex})(?=\b|[^a-z])/) { "#{$1 && '_'.freeze }#{$2.downcase}" }
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word.tr!("-".freeze, "_".freeze)
      word.downcase!
      word
    end
  end
end
