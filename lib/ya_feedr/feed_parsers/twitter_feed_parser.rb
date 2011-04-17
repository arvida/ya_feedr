class TwitterFeedParser < YaFeedr::Feed
  def feed_url
    @feed_url ||= "http://search.twitter.com/search.rss?q=from:#{settings[:username]}"
  end

  def parse_item(data)
    {
        :body => data.css('description').first.content,
        :created_at => Time.parse(data.css('pubDate').first.content),
        :feed => {:name => "Twitter", :link => "http://twitter.com/#{settings[:username]}"}
    }
  end
end

YaFeedr::Feed.register_feed_parser :twitter, TwitterFeedParser
