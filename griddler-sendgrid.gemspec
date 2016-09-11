# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'griddler/sendgrid/version'

Gem::Specification.new do |spec|
  spec.name          = 'griddler-sendgrid'
  spec.version       = Griddler::Sendgrid::VERSION
  spec.authors       = ['Caleb Thompson']
  spec.email         = ['caleb@calebthompson.io']
  spec.summary       = 'SendGrid adapter for Griddler'
  spec.description   = 'Adapter to allow the use of SendGrid Parse API with Griddler'
  spec.homepage      = 'https://github.com/thoughtbot/griddler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.5'

  spec.add_dependency 'griddler'
end
