lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ndd/rspec/rails/version'

Gem::Specification.new do |spec|

  spec.name = 'ndd-rspec-rails'
  spec.version = Ndd::Rspec::Rails::VERSION
  spec.authors = ['David DIDIER']
  spec.email = ['c_inconnu2@yahoo.fr']

  spec.summary = 'RSpec utilities for Rails'
  spec.description = 'RSpec utilities for Rails'
  spec.homepage = 'http://github.com/ddidier/ndd-rspec-rails'
  spec.license = 'MIT'

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.2.0'

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.extra_rdoc_files = %w[README.md]
  spec.files = Dir['bin/*', '{lib}/**/*.rb', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'LICENSE', 'README.md']
  spec.require_path = 'lib'

  spec.add_runtime_dependency 'activesupport', '~> 5.1.0'

  spec.add_development_dependency 'bundler', '~> 1.14.0'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  spec.add_development_dependency 'guard', '~> 2.14.0'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.0'
  spec.add_development_dependency 'rake', '~> 12.0.0'
  spec.add_development_dependency 'rspec', '~> 3.6.0'
  spec.add_development_dependency 'rubocop', '~> 0.48.0'
  spec.add_development_dependency 'simplecov', '~> 0.14.0'
  spec.add_development_dependency 'yard', '~> 0.9.0'

end
