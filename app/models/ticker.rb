class Ticker < ApplicationRecord
  has_many :stocks

  before_save :upcase_symbol

  validate :validate_symbol

  def update_price
    response = api_call
    self.last_updated_price = latest_price(response)
    self.last_updated_time = DateTime.now
  end

private

  def validate_symbol
    response = api_call

    if valid_symbol?(response)
      self.last_updated_price = latest_price(response)
      self.last_updated_time = DateTime.now
    else
      errors.add(:symbol, :invalid)
    end
  end

  def api_call
    response = RestClient.get("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{self.symbol}&interval=1min&apikey=#{ENV.fetch('ALPHA_VANTAGE')}")
    JSON.parse(response)
  end

  def latest_price(response)
    response.fetch("Time Series (1min)").first[1].fetch("4. close")
  end

  def valid_symbol?(response)
    response.fetch("Time Series (1min)", false)
  end

  def upcase_symbol
    self.symbol = symbol.upcase
  end

end
