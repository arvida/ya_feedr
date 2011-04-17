module YaFeedr
  class App < Sinatra::Base
    set :haml, :format => :html5

    helpers do
      def render_item(feed_item)
        haml YaFeedr::App.template_file(feed_item.parser.template), :locals => {:item => feed_item}, :layout => false
      end
    end

    get '/' do
      @per_page = 25
      @page = params[:page] ? params[:page].to_i : 1
      @pages = (YaFeedr::FeedItem.count/@per_page).to_i
      @feed_items = YaFeedr::FeedItem.limit(@per_page).skip((@page.to_i-1)*@per_page).sort(:created_at.desc).all
      haml :index
    end

    get '/style.css' do
      content_type 'text/css'
      response.headers['Cache-Control'] = 'public, max-age=30000'
      YaFeedr::App.static_file('style.css')
    end

    template :layout do
      @layout ||= template_file('layout.haml')
    end

    template :index do
      @index ||= template_file('index.haml')
    end

    class << self
      def template_file(filename)
        File.read YaFeedr.config.file_path File.join('views', File.basename(filename))
      end

      def static_file(filename)
        File.read YaFeedr.config.file_path File.join('public', File.basename(filename))
      end
    end
  end
end
