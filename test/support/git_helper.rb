module GitHelper
  include Bash

  def commit_branch(branch_name, file_name)
    bash(from: REPOSITORY, silent: true) do
      "
      git checkout #{branch_name}
      touch #{file_name}
      git add -A
      git commit -m 'add #{file_name}'
      "
    end
  end

  def checkout(branch_name)
    bash(from: REPOSITORY, silent: true) do
      "git checkout #{branch_name}"
    end
  end
end
