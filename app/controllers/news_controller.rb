class NewsController < ApplicationController
  def index
    cached_news = Rails.cache.fetch("recent_news", expires_in: 10.minutes) do
      News.only(:title, :source, :url, :scraped_at).order(created_at: :desc).limit(20).to_a
    end

    render json: cached_news
  end
end
