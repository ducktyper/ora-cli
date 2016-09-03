# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ora/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "ora-cli"
  spec.version       = Ora::Cli::VERSION
  spec.authors       = ["Ducksan Cho"]
  spec.email         = ["ducktyper@gmail.com"]

  spec.summary       = "ORA CLI"
  spec.description   = "ORA CLI"
  spec.homepage      = "https://orahq.com"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["ora-install", "ora-uninstall"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
