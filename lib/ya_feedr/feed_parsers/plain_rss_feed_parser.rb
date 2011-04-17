class PlainRssFeedParser < YaFeedr::Feed
  def feed_url
    @feed_url ||= settings[:url]
  end

end

YaFeedr::Feed.register_feed_parser :plain_rss, PlainRssFeedParser
