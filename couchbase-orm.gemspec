# frozen_string_literal: true

require File.expand_path('lib/couchbase_orm/version', __dir__)

Gem::Specification.new do |gem|
  gem.name = 'couchbase-orm'
  gem.version       = CouchbaseOrm::VERSION
  gem.license       = 'MIT'
  gem.authors       = ['Stephen von Takach']
  gem.email         = ['steve@cotag.me']
  gem.homepage      = 'https://github.com/cotag/couchbase-orm'
  gem.summary       = 'Couchbase ORM for Rails'
  gem.description   = 'A Couchbase ORM for Rails'

  gem.required_ruby_version = '>= 2.6.0'
  gem.require_paths = ['lib']

  gem.add_runtime_dependency     'activemodel',   ENV['ACTIVE_MODEL_VERSION'] || '>= 5.2'
  gem.add_runtime_dependency     'activerecord',  ENV['ACTIVE_MODEL_VERSION'] || '>= 5.2'

  gem.add_runtime_dependency     'couchbase'
  gem.add_runtime_dependency     'radix', '~> 2.2' # converting numbers to and from any base

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-stack_explorer'
  gem.add_development_dependency 'rake',         '~> 12.2'
  gem.add_development_dependency 'rspec',        '~> 3.7'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'yard', '~> 0.9'

  gem.files = `git ls-files`.split("\n")
  gem.metadata['rubygems_mfa_required'] = 'true'
end
