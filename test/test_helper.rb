$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'ora/cli'
require 'minitest/autorun'

REPOSITORY = "tmp/repository"

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|file| require file }

include Ora::Cli

include SetupTmp
include GitHelper
include BashHelper
