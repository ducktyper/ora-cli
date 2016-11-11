module GitHelper
  include BashHelper

  def commit_branch(branch_name, file_name, content = '')
    bash_repo("
      git checkout #{branch_name}
      touch #{file_name}
      echo '#{content}' > #{file_name}
      git add -A
      git commit -m 'add #{file_name}'
    ")
  end

  def commit_remote_branch(branch_name, file_name, content = '')
    bash_repo("
      git checkout #{branch_name}
      touch #{file_name}
      echo '#{content}' > #{file_name}
      git add -A
      git commit -m 'add #{file_name}'
      git push origin #{branch_name}
      git reset HEAD~ --hard
    ")
  end

  def dirty_branch(branch_name, file_name, content = '')
    bash_repo("
      git checkout #{branch_name}
      touch #{file_name}
      echo '#{content}' > #{file_name}
    ")
  end

  def checkout(branch_name)
    bash_repo("git checkout #{branch_name}")
  end

  def current_branch
    bash_repo('git branch | grep \\*').sub("*", "").strip
  end

  def push_branch(branch_name)
    bash_repo("git push origin #{branch_name}")
  end

  def remote_upto_date(branch_name)
    bash_repo("git checkout #{branch_name}")
    bash_repo("git push origin #{branch_name}").include? "Everything up-to-date"
  end
end
