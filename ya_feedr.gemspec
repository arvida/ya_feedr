# -*- encoding: utf-8 -*-
require File.expand_path("../lib/ya_feedr/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ya_feedr"
  s.version     = YaFeedr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Arvid Andersson"]
  s.email       = ["arvid@oktavilla.se"]
  s.homepage    = "http://github.org/arvida/ya_feedr"
  s.summary     = ""
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'sinatra', [">= 1.2.0"]
  s.add_dependency 'haml'
  s.add_dependency 'i18n'
  s.add_dependency 'bson'
  s.add_dependency 'bson_ext'
  s.add_dependency 'mongo_mapper'
  s.add_dependency 'nokogiri'
  s.add_dependency 'time-lord'
  s.add_dependency 'rake'

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency 'purdytest'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'webmock'

  s.files = Dir.glob("{test,lib}/**/*") + %w(README.textile ya_feedr.gemspec Gemfile)
  s.require_path = 'lib'
end
