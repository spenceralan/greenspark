class Ticker < ApplicationRecord
  has_many :stocks

  before_save :upcase_symbol

  validate :validate_symbol

  def update_price
    api_call = IexTrading.new(self)
    response = api_call.last_price
    self.last_updated_price = latest_price(response)
    self.last_updated_time = latest_time(response)
    save!
  end

private

  def validate_symbol
    api_call = IexTrading.new(self)
    response = api_call.last_price

    if valid_symbol?(response)
      self.last_updated_price = latest_price(response)
      self.last_updated_time = latest_time(response)
    else
      errors.add(:symbol, :invalid)
    end
  end

  def latest_price(response)
    return nil unless valid_symbol?(response)
    response.fetch("latestPrice")
  end

  def latest_time(response)
    return nil unless valid_symbol?(response)
    response.fetch("latestTime")
  end

  def valid_symbol?(response)
    return false if response == "Unknown symbol"
    true
  end

  def upcase_symbol
    return if symbol.nil?
    self.symbol = symbol.upcase
  end

end
