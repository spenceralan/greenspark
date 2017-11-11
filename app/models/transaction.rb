class Transaction < ApplicationRecord
  TRANSACTION_TYPES = { buy: 0, sell: 1 }

  enum trade_type: TRANSACTION_TYPES

  belongs_to :stock
  belongs_to :user

  before_save :update_total

  validates_presence_of :price, :quantity, :date, :trade_type
  validates_numericality_of :price, only_integer: false, allow_blank: true
  validates_numericality_of :quantity, only_integer: true, greater_than: 0, allow_blank: true
  validates_inclusion_of :trade_type, in: Transaction::TRANSACTION_TYPES.keys.map(&:to_s)
  validate :quantity_exceeds_available

  def update_total
    self.total = self.price * self.quantity
  end

  def default_price
    price || stock.ticker.last_updated_price
  end

private

  def quantity_exceeds_available
    return if stock.nil?
    return unless trade_type == "sell"

    errors.add(:quantity, "cannot exceed number of stocks owned - #{stock.quantity} #{"stock".pluralize(stock.quantity)} currently available") if quantity > stock.quantity
  end
end
