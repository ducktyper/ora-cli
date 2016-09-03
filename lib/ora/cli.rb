require "ora/cli/version.rb"
require "ora/cli/bash.rb"
require "ora/cli/path.rb"

module Ora
  module Cli
    def self.run
      project_path = `pwd`.strip
      remove_ext   = "sed 's/\.[^.]*$//'"

      task = Bash.new(project_path).select("ls #{Path.tasks} | #{remove_ext}")

      require "ora/cli/tasks/#{task}"
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").new(project_path).run
    end
  end
end
