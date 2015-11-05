$: << File.expand_path('../lib', __FILE__)
require 'mongoid/undo/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-undo'
  gem.version       = Mongoid::Undo::VERSION
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.homepage      = 'https://github.com/haihappen/mongoid-undo'
  gem.summary       = 'Super simple undo for your Mongoid app.'
  gem.description   = 'mongoid-undo provides a super simple and easy to use undo system for Mongoid apps.'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport', '~> 4.2.0'
  gem.add_dependency 'mongoid', '>= 4.0.0', '<= 6.0.0'
  gem.add_dependency 'mongoid-paranoia', '>= 1.3.0', '~> 1.1'
  gem.add_dependency 'mongoid-versioning', '>= 1.1.0', '~> 1.1'

  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'rake', '~> 10.0'
end
