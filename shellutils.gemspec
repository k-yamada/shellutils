# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shellutils/version'

Gem::Specification.new do |gem|
  gem.name          = "shellutils"
  gem.version       = Shellutils::VERSION
  gem.authors       = ["Kazuhiro Yamada"]
  gem.email         = ["kyamada@sonix.asia"]
  gem.description   = %q{Shell utils}
  gem.summary       = %q{Shell utils}
  gem.homepage      = "https://github.com/k-yamada/shellutils"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor'
  gem.add_development_dependency 'rspec'
end
