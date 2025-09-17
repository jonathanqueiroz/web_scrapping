class NewsScraperJob
  include Sidekiq::Job

  sidekiq_options retry: 2, queue: "default"

  def perform(provider)
    case provider
    when "g1"
      scrape_g1
    else
      LogError.create(message: "Provider não suportado: #{provider}")
    end
  rescue => e
    LogError.create(message: "Erro no NewsScraperJob: #{e.message}", backtrace: e.backtrace.join("\n"))
  end

  private

  def scrape_g1
    require "open-uri"
    require "nokogiri"

    url = "https://g1.globo.com/"
    doc = Nokogiri::HTML(URI.open(url))

    doc.css(".feed-post").each do |post|
      title = post.at_css(".feed-post-link")&.text&.strip
      link = post.at_css(".feed-post-link")&.[]("href")

      next if title.blank? || link.blank?
      news = News.where(title: title, url: link, source: "g1").first

      if news.blank?
        News.create!(title: title, url: link, source: "g1", scraped_at: Time.current)
      end
    end
  end
end
