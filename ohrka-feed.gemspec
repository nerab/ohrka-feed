# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohrka-feed/version'

Gem::Specification.new do |gem|
  gem.name          = "ohrka-feed"
  gem.version       = Ohrka::Feed::VERSION
  gem.authors       = ["Nicholas E. Rabenau"]
  gem.email         = ["nerab@gmx.net"]
  gem.description   = %q{Provides an RSS feed for http://www.ohrka.de/ until they provide one}
  gem.summary       = %q{RSS feed for ohrka.de}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'require_all'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'json'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-minitest'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'libnotify'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'rb-fsevent'  
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
