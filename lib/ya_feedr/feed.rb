module YaFeedr
  class Feed
    attr_reader :items
    attr_reader :settings
    attr_reader :parsed_document

    def initialize(settings = {})
      @items = []
      @settings = settings
    end

    def fetch_items
      if feed_url and @get_result = get_document(feed_url)
        document_items.each do |item_data|
          parse_item(item_data).tap do |parsed_item|
            parsed_item[:feed][:parser] = self.class.to_s
            @items << FeedItem.new(parsed_item)
          end
        end
      end
    end

    def parse_item(data)
      {
        :body => data.css('description').first.content,
        :created_at => Time.parse(data.css('pubDate').first.content),
        :feed => {:name => parsed_document.css('title').first.content, :link => parsed_document.css('link').first.content}
      }
    end

  protected
    def get_document(document_url)
      url  = URI.parse(document_url)
      req  = Net::HTTP::Get.new(url.path)
      http = Net::HTTP.new(url.host, url.port)
      begin
        result = http.start { |http| http.get("#{url.path}?#{url.query}", headers) }
        result if result.code == "200"
      rescue
        puts "* Unable to fetch: #{document_url}"
        puts "  ---> #{$!.inspect}"
        false
      end
    end

    def parsed_document
      Nokogiri::XML(@get_result.body)
    end

    def document_items
      parsed_document.css('item')
    end

    class << self
      def fetch_and_save_new_items
        YaFeedr.config.feeds.each do |_feed|
          parser_name, settings = _feed.keys.first, _feed.values.first
          if YaFeedr.feed_parsers.has_key?(parser_name)
            YaFeedr.feed_parsers[parser_name].new(settings).tap do |feed_parser|
              feed_parser.fetch_items
              feed_parser.items.each &:save if feed_parser.items.any?
            end
          end
        end
      end

      def register_feed_parser(name, _class)
        YaFeedr.feed_parsers[name] = _class  unless YaFeedr.feed_parsers.has_key?(name)
      end

      def template
        '_default_item.haml'
      end
    end

    def headers
      { "Content-Type" => 'application/rss' }
    end
  end
end
