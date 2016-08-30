module Ora
  module Cli
    def self.run task, from
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").new(from).run
    end
  end
end

require "ora/cli/bash.rb"
require "ora/cli/print.rb"
require "ora/cli/stdin.rb"
require "ora/cli/task.rb"
require "ora/cli/version.rb"
require "ora/cli/tasks/new_feature_branch.rb"
require "ora/cli/tasks/push_feature_branch.rb"
require "ora/cli/tasks/push_to_master.rb"
require "ora/cli/tasks/push_to_staging.rb"
require "ora/cli/tasks/push_to_uat.rb"
