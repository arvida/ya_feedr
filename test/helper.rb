ENV[_'RACK_ENV'] = 'test'

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
  c.authentication = {:username => 'admin', :password => 'password'}
  # Feeds
  c.feeds.add :twitter, :username => 'twitter_user'
  c.feeds.add :plain_rss, :url => 'http://example.com/feed.rss'
end
