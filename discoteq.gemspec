$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'discoteq/version'

Gem::Specification.new do |spec|
  spec.name = 'discoteq'
  spec.author = 'Joseph Anthony Pasquale Holsten'
  spec.email = 'joseph@josephholsten.com'
  spec.license = 'ISC'
  spec.version = Discoteq::VERSION
  spec.summary = 'A service discovery toolkit for all and none'
  spec.files = `git ls-files`.split(/\r?\n\r?/)
  spec.executables = spec.files.grep(/^bin/) {|f| File.basename f}
  spec.test_files = spec.files.grep(%r{^test/unit/.*test_.*\.rb$})

  # absolutely must be above this level
  spec.add_development_dependency 'berkshelf', '>= 3'
  spec.add_development_dependency 'chef', '>= 11'

  spec.add_development_dependency 'kitchen-vagrant', '>= 0.14.0'
  spec.add_development_dependency 'test-kitchen', '>= 1.1.1'
  spec.add_development_dependency 'rake', '>= 10.1.0'
  spec.add_development_dependency 'rubocop', '>= 0.23.0'
  spec.add_development_dependency 'guard', '>= 2.1.1'
  spec.add_development_dependency 'guard-minitest', '>= 1.0.0'
  spec.add_development_dependency 'minitest', '>= 5.0.0'
  spec.add_development_dependency 'chef-zero'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rr'
end
