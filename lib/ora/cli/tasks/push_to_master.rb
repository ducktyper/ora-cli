require 'ora/cli/task'

module Ora::Cli
  class PushToMaster < Task
    attr_reader :version

    def commands
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

    private
    def set_version
      puts_plain "Latest versions:"
      puts_plain latest_versions
      puts_plain "Enter to use #{recommend_version} or type new version:"
      print_plain "New Version: "
      @version = Stdin.new(inputs).gets /^(v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)?$/
      @version = recommend_version if @version.empty?
    end
    def latest_versions
      @latest_versions ||=
        bash('git tag', from: @from, silent: true).split("\n").
          select {|tag| tag.match /^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/}.
          map    {|tag| Gem::Version.create(tag.sub(/^v/, ''))}.sort.last(5).
          map    {|ver| "v#{ver}"}
    end
    def recommend_version
      @recommend_version ||=
        latest_versions.last.to_s.sub(/\.(\d+)$/, '.') + ($1.to_i + 1).to_s
    end

    def show_slack_message
      puts_green "Paste below to slack"
      puts_plain ":merge: #{branch} => develop\n:merge: develop => master\n:monorail: production"
    end
  end
end
