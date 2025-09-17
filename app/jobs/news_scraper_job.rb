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
  end

  private

  def scrape_g1
    require "open-uri"
    require "nokogiri"
    require "semian"

    url = "https://g1.globo.com/"

    begin
      Semian[:g1_scraper].acquire do
        doc = Nokogiri::HTML(URI.open(url))

        doc.css(".feed-post").each do |post|
          title = post.at_css(".feed-post-link")&.text&.strip
          link = post.at_css(".feed-post-link")&.[]("href")

          next if title.blank? || link.blank?
          next if link.match?(/ao[-]?vivo/i)

          news = News.where(title: title, url: link, source: "g1").first

          if news.blank?
            News.create!(title: title, url: link, source: "g1", scraped_at: Time.current)
          end
        end
      end
    rescue Semian::OpenCircuitError => e
      LogError.create(message: "Circuit breaker aberto para G1: #{e.message}")
    rescue => e
      LogError.create(message: "Erro no NewsScraperJob: #{e.message}", backtrace: e.backtrace.join("\n"))
    end
  end
end
