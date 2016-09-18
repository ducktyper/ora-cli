require "ora/cli/version"
require "ora/cli/bash"
require "ora/cli/path"
require "ora/cli/task"

module Ora
  module Cli
    def self.run
      project_path = `pwd`.strip
      remove_ext   = "sed 's/\.[^.]*$//'"

      unless `cat #{Task::CONTINUE_FILE}`.empty?
        continue = JSON.parse(File.read(File.expand_path(Task::CONTINUE_FILE)))

        task = continue['task']
        require "ora/cli/tasks/#{task}"

        class_name = task.split('_').map(&:capitalize).join
        Object.const_get("Ora::Cli::#{class_name}").
          new(project_path).
          continue(continue)

        return
      end

      task = Bash.new(project_path).select("ls #{Path.tasks} | #{remove_ext}")

      require "ora/cli/tasks/#{task}"
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").new(project_path).run
    end
  end
end
