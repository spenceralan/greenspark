class Ticker < ApplicationRecord
  has_many :stocks
  has_many :closing_prices

  before_save :upcase_symbol

  # re-enable with bigger database
  # after_create :save_historical_data

  validate :validate_symbol

  def update_price
    response = last_price_api_call
    self.last_updated_price = latest_price(response)
    self.last_updated_time = DateTime.now
  end

  def closing_price(date)
    closing_prices.where(date: date)
  end

  def save_historical_data
    api_call = AlphaVantage.new(self)
    history_attrs = api_call.full_closing_price_history.map do |row|
      {date: row['timestamp'], price: row['close'], ticker_id: id}
    end
    ClosingPrice.bulk_insert do |worker|
      history_attrs.each do |attrs|
        worker.add(attrs)
      end
    end
  end

  def self.update_closing_prices
    find_each do |ticker|
      api_call = AlphaVantage.new(ticker)
      api_call.compact_closing_price_history.each do |row|
        closing_price = ClosingPrice.where(date: row["timestamp"]).where(ticker: ticker)
        unless closing_price.present?
          ticker.closing_prices.create({date: row['timestamp'], price: row['close']})
        end
      end
    end
  end
private

  def validate_symbol
    api_call = AlphaVantage.new(self)
    response = api_call.last_price

    if valid_symbol?(response)
      self.last_updated_price = latest_price(response)
      self.last_updated_time = DateTime.now
    else
      errors.add(:symbol, :invalid)
    end
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
