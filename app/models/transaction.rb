class Transaction < ApplicationRecord
  belongs_to :stock

  before_create :update_total

  def update_total
    self.total = self.price * self.quantity
  end
end
