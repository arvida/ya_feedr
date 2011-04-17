require "ya_feedr"

task :ya_feedr_update_feeds do
  YaFeedr::Feed.fetch_and_save_new_items
end
