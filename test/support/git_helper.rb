module GitHelper
  include Bash
  include BashHelper

  def commit_branch(branch_name, file_name)
    bash_repo("
      git checkout #{branch_name}
      touch #{file_name}
      git add -A
      git commit -m 'add #{file_name}'
    ")
  end

  def commit_remote_branch(branch_name, file_name)
    bash_repo("
      git checkout #{branch_name}
      touch #{file_name}
      git add -A
      git commit -m 'add #{file_name}'
      git push origin #{branch_name}
      git reset HEAD~ --hard
    ")
  end

  def checkout(branch_name)
    bash_repo("git checkout #{branch_name}")
  end

  def push_branch(branch_name)
    bash_repo("git push origin #{branch_name}")
  end
end
