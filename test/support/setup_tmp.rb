module SetupTmp
  include Bash

  def reset_tmp
    bash(print: Print.new(true)) do
      "
      rm -rf tmp
      mkdir tmp tmp/remote tmp/repository
      "
    end
    bash(from: 'tmp/remote', print: Print.new(true)) do
      "
      git init --bare
      "
    end
    bash(from: 'tmp/repository', print: Print.new(true)) do
      "
      git init
      git remote add origin ../remote
      touch a.txt
      git add -A
      git commit -m 'add a.txt'
      git push origin master
      git checkout -b develop
      git push origin develop
      git checkout -b staging
      git push origin staging
      git checkout -b uat
      git push origin uat
      git checkout develop
      "
    end
  end

  def delete_tmp
    bash(print: Print.new(true)) {"rm -rf ../tmp"}
  end
end
