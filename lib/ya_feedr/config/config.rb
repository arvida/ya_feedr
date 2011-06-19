module YaFeedr
  class Config
    attr_accessor :title, :about, :feeds, :authentication

    def file_path(path)
      File.exists?(File.join(YaFeedr::Config.app_root, path)) ? File.join(YaFeedr::Config.app_root, path) : File.join(YaFeedr::Config.root, path)
    end

    def feeds
      @feeds ||= Feeds.new
    end

    class << self
      # Path to gems lib/ya_feedr dir
      def root
        @root ||= File.expand_path( File.dirname(__FILE__)+'/..' )
      end

      # Path dir where the app is run from
      def app_root
        @app_root ||= Dir.pwd
      end
    end
  end
end
