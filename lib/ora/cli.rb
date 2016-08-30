require "ora/cli/version.rb"

module Ora
  module Cli
    def self.run task, from
      require "ora/cli/tasks/#{task}"
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").new(from).run
    end
  end
end
