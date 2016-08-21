require 'test_helper'

class CreateNewFeatureBranchTest < Minitest::Test
  include Bash
  def setup

    bash(silent: true) do
      "
      rm -rf tmp
      mkdir tmp
      mkdir tmp/remote
      mkdir tmp/repository
      "
    end

    bash(from: 'tmp/remote', silent: true) do
      "
      git init --bare
      "
    end

    bash(silent: true) do
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

  def teardown
    `rm -rf ../tmp`
  end

  def test_run_method_defined
    CreateNewFeatureBranch.new.run
  end
end
