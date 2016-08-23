module Ora
  module Cli
  end
end

Dir[File.dirname(__FILE__) + '/cli/**/*.rb'].each {|file| require file }

