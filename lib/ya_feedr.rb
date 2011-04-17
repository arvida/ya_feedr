require 'sinatra'
require 'nokogiri'
require 'mongo_mapper'
require 'i18n'
require 'net/http'
require 'digest/sha1'
require 'time-lord'
require 'rake'

module YaFeedr
  extend self
  attr_reader :config
  attr_reader :feed_parsers

  def config
    raise "Please setup YaFeedr before using" unless @config
    @config
  end

  def configure
    yield @config ||= YaFeedr::Config.new
  end

  def feed_parsers
    @feed_parsers ||= {}
  end
end

if ENV['MONGOHQ_URL']
  MongoMapper.config = {ENV['RACK_ENV'] => {'uri' => ENV['MONGOHQ_URL']}}
else
  MongoMapper.config = {ENV['RACK_ENV'] => {'uri' => 'mongodb://localhost/ya_feedr'}}
end
MongoMapper.connect(ENV['RACK_ENV'])

require 'ya_feedr/config'
require 'ya_feedr/helpers'
require 'ya_feedr/app'
require 'ya_feedr/feed'
require 'ya_feedr/feed_item.rb'
require 'ya_feedr/tasks/update_feeds'
Dir[File.dirname(__FILE__) + '/ya_feedr/feed_parsers/*.rb'].each {|file| require file }
require File.join(YaFeedr::Config.app_root, 'ya_feedr')
