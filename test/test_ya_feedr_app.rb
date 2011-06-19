require_relative 'helper'

class TestYaFeedr < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include WebMock::API

  def setup
    WebMock.disable_net_connect!
  end

  def app; YaFeedr::App; end

  def test_title_and_about_text
    get '/'
    assert last_response.body.include?('My mix of rss feeds'), 'should have have title'
    assert last_response.body.include?('A bit of info'), 'should have have title'
  end

  def test_render_feed_items
    stub_feed_requests
    # Update feeds
    authorize 'admin', 'password'
    post '/update'

    get '/'
    assert_equal 200, last_response.status
    assert last_response.body.include?('Looking for some new top notch accounts to follow?'), 'should have have items from twitter feed'
    assert last_response.body.include?('A peak of 5,531 TPS (tweets per second)'), 'should have have items from twitter feed'
    assert last_response.body.include?('You can find a variety of sound effects'), 'should have have items description from rss feed'
    assert last_response.body.include?('RSS has become a useful tool'), 'should have have items description from rss feed'
  end

  def test_update_for_require_auth
    post '/update'
    assert_equal 401, last_response.status
  end

  def test_update_with_bad_credentials
    authorize 'bad_username', 'bad_password'
    post '/update'
    assert_equal 401, last_response.status
  end

  def test_update
    stub_feed_requests
    authorize 'admin', 'password'
    post '/update'
    assert_equal 200, last_response.status
    assert_equal 'Feeds updated', last_response.body
  end

private
  def stub_feed_requests
    stub_request(:get, 'example.com/feed.rss?').to_return(File.new('test/data/rssfeed_output.txt'))
    stub_request(:get, 'search.twitter.com/search.rss?q=from:twitter_user').to_return(File.new('test/data/twitter_output.txt'))
  end
end
