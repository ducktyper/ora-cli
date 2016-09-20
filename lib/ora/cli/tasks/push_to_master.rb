require 'ora/cli/task'

module Ora::Cli
  class PushToMaster < Task
    attr_reader :version

    def commands
      '
      :clean_on_main_branch!
      git stash save -u "OraCli"
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
      :apply_stash
      :slack_message_to_paste
      '
    end

    private
    def set_version
      return '' if tag_message.empty?

      print.plain "Latest versions:"
      print.plain latest_versions
      print.plain tag_message
      print.plain "Enter to use #{recommend_version} or type new version:"
      print.inline "New Version: "
      @version = stdin.gets(/^(v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)?$/)
      @version = recommend_version if @version.empty?

      '
      git tag -a "#{version}" -m "#{tag_message}"
      git push --tags
      '
    end
    def latest_versions
      @latest_versions ||=
        @bash.silent('git tag').split("\n").
          select {|tag| tag.match(/^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/)}.
          map    {|tag| Gem::Version.create(tag.sub(/^v/, ''))}.sort.last(5).
          map    {|ver| "v#{ver}"}.join("\n")
    end
    def latest_version
      @latest_version ||= latest_versions.split("\n").last.to_s
    end
    def recommend_version
      @recommend_version ||= latest_version.sub(/\.(\d+)$/, '.') + ($1.to_i + 1).to_s
    end

    def slack_message_to_paste
      print.plain ":merge: #{branch} => develop\n:merge: develop => master\n:monorail: production"
      ''
    end

    def apply_stash
      return '' if target_stash_revision.empty?

      "git stash pop #{target_stash_revision}"
    end
    def target_stash_revision
      @target_stash_revision ||=
        @bash.silent("git stash list | grep '#{target_stash_name}' | sed s/:.*//").
          split("\n").first.to_s.strip
    end
    def target_stash_name
      "On #{branch}: OraCli"
    end

    def tag_message
      return @tag_message if @tag_message
      messages = []
      @bash.silent("git log --merges --pretty=oneline #{latest_version}..HEAD").split("\n").each do |commit|
        match = commit.match(/^[0-9a-z]+ Merge pull request #(\d+) from (.*)$/)
        next if match.nil?

        pull_request = match[1]
        branch_name  = match[2]

        messages << "#{pull_request} #{branch_name}"
      end
      @tag_message = messages.join("\n")
    end
  end
end
