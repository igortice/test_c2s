require "faraday"
require "nokogiri"
require "dry/monads"
require "dry/monads/do"
require "dry-initializer"
require "logger"
require "uri"

class WebScraperService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  # Define as opções esperadas com validação embutida
  option :url, proc { |value| validate_url(value) }
  option :user_agent, default: -> { default_user_agent }
  option :logger, default: -> { Logger.new($stdout) }

  def call
    html = yield fetch_html
    data = yield parse_html(html)

    Success(data)
  rescue StandardError => e
    logger.error("WebScraperService Error: #{e.message} (#{e.class})")
    Failure({ error: e.message, backtrace: e.backtrace[0..5] })
  end

  private

  def fetch_html
    response = Faraday.get(url) do |req|
      req.headers["User-Agent"]      = user_agent
      req.headers["Referer"]         = url
      req.headers["Accept-Language"] = "en-US,en;q=0.9"
    end

    if response.success?
      logger.info("Successfully fetched HTML from #{url}")
      Success(response.body)
    else
      log_failure(response.status, response.body)
      Failure({ error: "Failed to fetch page: #{response.status}" })
    end
  rescue Faraday::TimeoutError
    logger.error("Request to #{url} timed out")
    Failure({ error: "Request timed out" })
  rescue Faraday::ConnectionFailed => e
    logger.error("Connection error to #{url}: #{e.message}")
    Failure({ error: "Connection error: #{e.message}" })
  rescue Faraday::Error => e
    logger.error("HTTP error fetching #{url}: #{e.message}")
    Failure({ error: "HTTP error: #{e.message}" })
  end

  def parse_html(html)
    doc = Nokogiri::HTML(html)

    marca  = doc.at_css("div#ctdoTopo h1.titulo-sm strong")&.text&.strip
    modelo = extract_model(doc, marca)
    preco  = doc.at_css("h2.preco")&.text&.strip

    if marca && preco
      logger.info("Successfully parsed data from HTML")
      Success({
                marca:  marca,
                modelo: modelo,
                preco:  preco
              })
    else
      logger.warn("Failed to parse required fields from HTML at #{url}")
      Failure({ error: "Failed to parse required fields from HTML" })
    end
  rescue Nokogiri::SyntaxError => e
    logger.error("HTML parsing error for #{url}: #{e.message}")
    Failure({ error: "HTML parsing error: #{e.message}" })
  end

  def extract_model(doc, marca)
    full_title = doc.at_css("div#ctdoTopo h1.titulo-sm")&.text&.strip
    return nil unless full_title

    full_title.gsub(marca.to_s, "").strip
  end

  def default_user_agent
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
  end

  def log_failure(status, body)
    logger.error("Failed to fetch HTML from #{url} - Status: #{status}, Body: #{body[0..100]}")
  end

  # Validação de URL como método de classe
  def self.validate_url(value)
    uri = URI.parse(value)
    raise ArgumentError, "Invalid URL: #{value}" unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    value
  rescue URI::InvalidURIError
    raise ArgumentError, "Invalid URL format: #{value}"
  end
end
