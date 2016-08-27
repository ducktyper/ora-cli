module BashHelper
  def bash_repo(commands)
    Bash.new(self, from: REPOSITORY, print: Print.new(true)).run commands
  end
end
