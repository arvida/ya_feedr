require_relative 'helper'

class TestYaFeedr < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app; YaFeedr::App; end

  def test_title_and_about_text
    get '/'
    assert last_response.body.include?('My mix of rss feeds'), 'should have have title'
    assert last_response.body.include?('A bit of info'), 'should have have title'
  end

  def test_render_feed_items
    authorize 'admin', 'password'
    post '/update'

    get '/'
    assert_equal 200, last_response.status
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
    authorize 'admin', 'password'
    post '/update'
    assert_equal 200, last_response.status
    assert_equal 'Feeds updated', last_response.body
  end
end
