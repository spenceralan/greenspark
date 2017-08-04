class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :symbol,
    :name,
    :description,
    presence: true

  validate :validate_symbol


  def cost
    transactions.sum(:total)
  end

  def quantity
    transactions.sum(:quantity)
  end

  def value
    quantity * last_updated_price
  end

  def change
    return 0 if cost == 0
    percent = ((value - cost) / cost) * 100
    percent.round(2)
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

  def update_price
    response = api_call
    self.last_updated_price = latest_price(response)
    self.last_updated_time = DateTime.now
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


end
