# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitestrings/version'

Gem::Specification.new do |spec|
  spec.name          = "kitestrings"
  spec.version       = Kitestrings::VERSION
  spec.authors       = ["Tom Ridge", "Matt Connolly", "Geoffrey Donaldson", "Nigel Rausch"]
  spec.email         = ["tom.ridge@tworedkites.com", "matt.connolly@tworedkites.com",
                        "geoffrey.donaldson@tworedkites.com", "nigel.rausch@tworedkites.com"]
  spec.summary       = %q{For all the 2rk goodness}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 3.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "sqlite3"
end
