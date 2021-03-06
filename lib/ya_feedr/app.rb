module YaFeedr
  class App < Sinatra::Base
    helpers YaFeedr::Helpers

    set :haml, :format => :html5

    get '/' do
      @per_page = 25
      @page = params[:page] ? params[:page].to_i : 1
      @pages = (YaFeedr::FeedItem.count/@per_page).to_i
      @feed_items = YaFeedr::FeedItem.limit(@per_page).skip((@page.to_i-1)*@per_page).sort(:created_at.desc).all
      haml :index
    end

    post '/update' do
      protected!
      YaFeedr::Feed.fetch_and_save_new_items
      [200, 'Feeds updated']
    end

    get '/rss' do
      @feed_items = YaFeedr::FeedItem.limit(10).sort(:created_at.desc).all
      response.headers['Cache-Control'] = 'public, max-age=3600'
      content_type 'application/rss+xml'
      haml(:rss, :format => :xhtml, :escape_html => true, :layout => false)
    end

    get '/style.css' do
      content_type 'text/css'
      response.headers['Cache-Control'] = 'public, max-age=3600'
      YaFeedr::App.static_file('style.css')
    end

    template :layout do
      @layout ||= template_file('layout.haml')
    end

    template :index do
      @index ||= template_file('index.haml')
    end

    template :rss do
      @rss ||= template_file('rss.haml')
    end

    class << self
      def template_file(filename)
        File.read YaFeedr.config.file_path(File.join('views', File.basename(filename)))
      end

      def static_file(filename)
        File.read YaFeedr.config.file_path(File.join('public', File.basename(filename)))
      end
    end
  end
end
