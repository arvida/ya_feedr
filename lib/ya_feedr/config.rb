module YaFeedr
  class Config
    attr_accessor :title, :about, :feeds
    # Path to gems lib/ya_feedr dir
    def root
      @root ||= File.expand_path( File.dirname(__FILE__) )
    end

    # Path dir where the app is run from
    def app_root
      @app_root ||= Dir.pwd
    end

    def file_path(path)
      File.exists?(File.join(YaFeedr.config.app_root, path)) ? File.join(YaFeedr.config.app_root, path) : File.join(YaFeedr.config.root, path)
    end
  end
end