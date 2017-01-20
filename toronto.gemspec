# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bootstrap/generators/version"

Gem::Specification.new do |spec|
  spec.name          = 'toronto'
  spec.version       = Bootstrap::Generators::VERSION
  spec.authors       = ['Cédric Zuger']
  spec.email         = ['zuger.cedric@gmail.com']
  spec.summary       = 'inTernatiOnalization Ready bOotstrap geNeraTOr'
  spec.description   = 'This is a fork of Twitter Bootstrap generators where static fields are translated fields.'
  spec.homepage      = 'https://github.com/czuger/toronto'
  spec.license       = 'MIT'

  # spec.rubyforge_project = "bootstrap-generators"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'railties', '>= 3.1.0'
  spec.add_runtime_dependency 'haml-rails', '>= 0.9.0'

end
