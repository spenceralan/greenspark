class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :ticker
  has_many :transactions, dependent: :destroy

  before_validation :set_ticker
  before_save :upcase_symbol

  validates :symbol,
    :name,
    :description,
    presence: true

  def cost
    transactions.sum(:total)
  end

  def quantity
    transactions.sum(:quantity)
  end

  def value
    quantity * ticker.last_updated_price
  end

  def change
    return 0 if cost == 0
    percent = ((value - cost) / cost) * 100
    percent.round(2)
  end

private

  def upcase_symbol
    self.symbol = symbol.upcase
  end

  def set_ticker
    self.ticker = Ticker.find_or_initialize_by(symbol: symbol)
    return unless ticker.new_record?

    unless ticker.save
      ticker.errors[:symbol].each do |error|
        errors.add(:symbol, error)
      end

      arr = ticker.errors.keys
      unless (arr - [:symbol]).empty?
        raise "don't know how to recover when ticker has errors on anything other than symbol. errors were: #{ticker.errors.full_messages.to_sentence}"
      end
    end
  end
end
