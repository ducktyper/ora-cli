module BashHelper
  def bash_repo(command)
    bash(from: REPOSITORY, print: Print.new(true)) {command}
  end
end
