module BashHelper
  def bash_repo(command)
    bash(from: REPOSITORY, silent: true) {command}
  end
end
