require File.expand_path("../config/environment", __dir__)
require "clockwork"
require "sidekiq/clockwork"

module Clockwork
  every(5.minutes, "news_scraper.g1") do
    NewsScraperJob.perform_async("g1")
  end
end
