YaFeedr.configure do |c|
  c.title = "My title"
  c.about = %q{My about text}
  c.authentication = {:username => 'admin', :password => 'password'}

#  c.feeds.add :twitter, :username => 'YOUR TWITTER USERNAME'
#  c.feeds.add :lastfm_loved_tracks, :username => 'YOUR LAST FM USERNAME'
#  c.feeds.add :flickr, :username => 'YOUR FLICKR USERNAME'
#  c.feeds.add :plain_rss, :url => 'http://YOUR-BLOCK-URL/feed.rss'
end
