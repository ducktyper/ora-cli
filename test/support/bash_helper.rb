module BashHelper
  def bash_repo(command)
    Bash.new.bash(self, from: REPOSITORY, print: Print.new(true)) {command}
  end
end
