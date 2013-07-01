# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clockpunch/version'

Gem::Specification.new do |spec|
  spec.name          = "clockpunch"
  spec.version       = Clockpunch::VERSION
  spec.authors       = ["Jason Hanggi"]
  spec.email         = ["jason@tablexi.com"]
  spec.description   = %q{Calculate durations from text input}
  spec.summary       = %q{Calculate durations from text input}
  spec.homepage      = "https://github.com/tablexi/clockpunch"
  spec.license       = "MIT"

  spec.files         = `git ls-files | grep -v source/`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sass"
  spec.add_dependency "coffee-script"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
