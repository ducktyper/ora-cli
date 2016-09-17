require "ora/cli/bash"

module SetupTmp
  def reset_tmp
    Bash.new(self, print: Print.new(true)).run '
      rm -rf tmp
      mkdir tmp tmp/remote tmp/repository
    '
    Bash.new(self, from: 'tmp/remote', print: Print.new(true)).run '
      git init --bare
    '
    Bash.new(self, from: 'tmp/repository', print: Print.new(true)).run '
      git init
      git remote add origin ../remote
      touch a.txt
      git add -A
      git commit -m "add a.txt"
      git push origin master
      git checkout -b develop
      git push origin develop
      git checkout -b staging
      git push origin staging
      git checkout -b uat
      git push origin uat
      git checkout -b aus
      git push origin aus
      git checkout develop
    '
  end

  def delete_tmp
    `rm -rf ../tmp`
  end
end
