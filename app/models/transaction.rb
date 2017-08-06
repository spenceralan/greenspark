class Transaction < ApplicationRecord

  TRANSACTION_TYPES = ["buy", "sell"]

  belongs_to :stock

  before_save :update_total

  validates_presence_of :price, :quantity, :date, :trade_type
  validates_numericality_of :price, only_integer: false, allow_blank: true
  validates_numericality_of :quantity, only_integer: true, greater_than: 0, allow_blank: true
  validates_inclusion_of :trade_type, in: TRANSACTION_TYPES

  def update_total
    self.total = self.price * self.quantity
  end

  def default_price
    price || stock.last_updated_price
  end
end
