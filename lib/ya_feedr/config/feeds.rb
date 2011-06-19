module YaFeedr
  class Feeds
    include Enumerable

    def initialize
      @feeds = []
    end

    def add(parser, settings)
      @feeds.push({ parser => settings })
    end

    def each
      @feeds.each {|f| yield(f) }
    end
  end
end
