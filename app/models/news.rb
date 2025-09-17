class News
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,      type: String
  field :url,        type: String
  field :source,     type: String
  field :scraped_at, type: Time

  after_create :clear_cache

  private

  def clear_cache
    Rails.cache.delete("recent_news")
  end
end
