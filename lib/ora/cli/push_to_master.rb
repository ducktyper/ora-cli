require 'ora/cli/task'

module Ora::Cli
  class PushToMaster < Task
    attr_reader :version

    def run
      bash(from: @from, silent: @silent) do
        '
        :clean_branch!
        git checkout develop
        git pull origin develop
        git merge #{branch}
        git push origin develop
        git checkout master
        git pull origin master
        git merge develop
        git push origin master
        git fetch --tags
        :set_version
        git checkout #{branch}
        git tag -a "#{version}" -m "#{branch}"
        git push --tags
        :show_slack_message
        '
      end

    end

    private
    def clean_branch!
      if dirty?
        puts_red "Please clean the feature branch '#{branch}'!"
        return false
      end
    end
    def dirty?
      !bash('git status', from: @from, silent: true).include? 'nothing to commit'
    end

    def set_version
      puts "Latest versions:"
      puts latest_versions
      puts "Enter to use #{recommend_version} or type new version:"
      print_green "New Version: "
      @version = ""
      while @version.empty?
        @version = Stdin.new(inputs).gets
        @version = recommend_version if @version.empty?
        unless version? @version
          puts red "Invalid format!"
          @version = ""
        end
      end
    end
    def version? text
      text.match /^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/
    end
    def latest_versions
      @latest_versions ||=
        bash('git tag', from: @from, silent: true).split("\n").
          select {|tag| version? tag}.
          map    {|tag| Gem::Version.create(tag.sub(/^v/, ''))}.sort.last(5).
          map    {|ver| "v#{ver}"}
    end
    def recommend_version
      @recommend_version ||=
        latest_versions.last.to_s.sub(/\.(\d+)$/, '.') + ($1.to_i + 1).to_s
    end

    def show_slack_message
      puts_green "Paste below to slack"
      puts ":merge: #{branch} => develop\n:merge: develop => master\n:monorail: production"
    end
  end
end
