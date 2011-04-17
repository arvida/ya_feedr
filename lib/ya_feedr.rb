require 'sinatra'
require 'nokogiri'
require 'mongo_mapper'
require 'i18n'
require 'net/http'
require 'digest/sha1'
require 'time-lord'

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

if ENV['MONGOHQ_HOST']
  puts "Running on MongoHQ"
  MongoMapper.connection = Mongo::Connection.new(ENV['MONGOHQ_HOST'], ENV['MONGOHQ_PORT'])
  MongoMapper.database = ENV['MONGOHQ_DATABASE']
  MongoMapper.database.authenticate(ENV['MONGOHQ_USER'],ENV['MONGOHQ_PASSWORD'])
else
  puts "Using local database"
  MongoMapper.database = 'ya_feedr'
end

require 'ya_feedr/config'
require 'ya_feedr/helpers'
require 'ya_feedr/app'
require 'ya_feedr/feed'
require 'ya_feedr/feed_item.rb'
Dir[File.dirname(__FILE__) + '/ya_feedr/feed_parsers/*.rb'].each {|file| require file }
