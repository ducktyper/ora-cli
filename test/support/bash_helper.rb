module BashHelper
  def bash_repo(command)
    Bash.new(self, from: REPOSITORY).bash(command, print: Print.new(true))
  end
end
