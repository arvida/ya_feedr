module YaFeedr
  module Helpers
    def render_item(feed_item)
      haml YaFeedr::App.template_file(feed_item.parser.template), :locals => {:item => feed_item}, :layout => false
    end

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [YaFeedr.config.authentication[:username], YaFeedr.config.authentication[:password]]
    end
  end
end
