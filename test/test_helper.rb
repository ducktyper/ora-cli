$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ora/cli'

require 'minitest/autorun'

include Ora::Cli

REPOSITORY = "tmp/repository"

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|file| require file }
include SetupTmp
include GitHelper
include BashHelper
