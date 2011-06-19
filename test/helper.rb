ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'purdytest'
require 'database_cleaner'
require 'webmock/test_unit'

require_relative '../lib/ya_feedr'

DatabaseCleaner[:mongo_mapper].strategy = :truncation
WebMock.disable_net_connect!

YaFeedr.configure do |c|
  c.title = 'My mix of rss feeds'
  c.about = 'A bit of info'
  c.feeds = [
    { :twitter => {:username => 'twitter_user'}},
    { :plain_rss => {:url => 'http://example.com/feed.rss'}}]
    c.authentication = {:username => 'admin', :password => 'password'}
end
