class Transaction < ApplicationRecord
  belongs_to :stock

  before_create :update_total

  def update_total
    self.total = self.price * self.quantity
  end

  def default_price
    price || stock.last_updated_price
  end
end
