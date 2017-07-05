require "ora/cli/version"
require "ora/cli/bash"
require "ora/cli/path"
require "ora/cli/task"

module Ora
  module Cli
    def self.run(custom_develop_branch)
      project_path = `pwd`.strip
      remove_ext   = "sed 's/\.[^.]*$//'"

      task = Bash.new(project_path).select("ls #{Path.tasks} | #{remove_ext}")

      require "ora/cli/tasks/#{task}"
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").
        new(project_path, develop_branch: custom_develop_branch).run
    end
  end
end
