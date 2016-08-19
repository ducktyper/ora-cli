require 'test_helper'

class Ora::CliTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ora::Cli::VERSION
  end
end
