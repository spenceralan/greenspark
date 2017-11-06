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

  def bought
    @transactions ||= transactions.where(trade_type: "buy")
  end

  def sold
    @sold ||= transactions.where(trade_type: "sell")
  end

  def cost
    @cost ||= bought.sum(:total) - sold.sum(:total)
  end

  def quantity
    @quantity ||= bought.sum(:quantity) - sold.sum(:quantity)
  end

  def value
    @value ||= quantity * ticker.last_updated_price
  end

  def change
    return 0 if cost == 0
    percent = ((value - cost) / cost) * 100
    percent.round(2)
  end

  def transactions_by_date_descending
    transactions.order("date DESC")
  end

  def transactions_by_date_ascending
    transactions.order(:date)
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
