module Ora::Cli
  class Path
    def self.tasks
      File.expand_path('../tasks', __FILE__)
    end

    def self.selecta
      File.expand_path('../../../../bin/ora_selecta', __FILE__)
    end
  end
end
