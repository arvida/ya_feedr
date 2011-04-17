class FlickrFeedParser < YaFeedr::Feed
  def feed_url
    return @feed_url if @feed_url.present?
    @flickr_url = "http://www.flickr.com/photos/#{settings[:username]}/"
    if flickr_page = get_document(@flickr_url)
      @feed_url = Nokogiri::XML(flickr_page.body).css("link[@type='application/rss+xml']").first["href"]
    end
  end

  def parse_item(data)
    {}.tap do |ret|
      data.xpath('media:thumbnail').first.tap do |thumbnail|
        ret[:thumbnail] = {:url => thumbnail['url'],
                           :width => thumbnail['width'],
                           :height => thumbnail['height']}
      end
      data.xpath('media:content').first.tap do |content|
        ret[:content] = {:url => content['url'],
                         :width => content['width'],
                         :height => content['height'],
                         :type => content['type']}
      end
      ret.merge!(:link => data.css('link').first.content,
                 :title => data.xpath('media:title').first.content,
                 :created_at => Time.parse(data.css('pubDate').first.content),
                 :feed => {:name => "Flickr", :link => @flickr_url})
    end
  end

  def self.template
    '_flickr_item.haml'
  end
end

YaFeedr::Feed.register_feed_parser :flickr, FlickrFeedParser
