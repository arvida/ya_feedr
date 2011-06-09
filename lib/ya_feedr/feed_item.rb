module YaFeedr
  class FeedItem
    include MongoMapper::Document

    key :body, String
    key :created_at, Time
    key :feed, Hash
    key :checksum, String

    ensure_index [[:created_at, -1]]

    before_validation :set_checksum

    validates_uniqueness_of :checksum

    def parser
      Kernel.const_get(feed[:parser])
    end

    def css_class
      @css_class ||= feed[:parser].gsub('FeedParser','')
    end

    def set_checksum
      self.checksum = Digest::SHA1.hexdigest([created_at, feed[:url]].join)
    end
  end
end
