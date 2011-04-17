class LastFMLovedTracksFeedParser < YaFeedr::Feed
  def feed_url
    @feed_url ||= "http://ws.audioscrobbler.com/2.0/user/#{settings[:username]}/lovedtracks.rss"
  end

  def parse_item(data)
    {
        :track_title => data.css('title').first.content,
        :track_link => data.css('description').first.content,
        :created_at => Time.parse(data.css('pubDate').first.content),
        :feed => {:name => "Last.fm", :link => "http://last.fm/user/#{settings[:username]}"}
    }
  end

  def self.template
    '_lastfm_item.haml'
  end
end

YaFeedr::Feed.register_feed_parser :lastfm_loved_tracks, LastFMLovedTracksFeedParser
