# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/fivethree_ionic/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-fivethree_ionic'
  spec.version       = Fastlane::FivethreeIonic::VERSION
  spec.author        = 'Marc Stammerjohann'
  spec.email         = 'marc@fivethree.io'

  spec.summary       = 'Fastlane plugin for Ionic v4 Projects'
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-fivethree_ionic"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.102.0')
end
