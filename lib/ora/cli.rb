module Ora
  module Cli
    def self.run task, from
      class_name = task.split('_').map(&:capitalize).join
      Object.const_get("Ora::Cli::#{class_name}").new(from).run
    end
  end
end

Dir[File.dirname(__FILE__) + '/cli/**/*.rb'].each {|file| require file }
