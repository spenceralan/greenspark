class AddPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :last_updated_price, :decimal, precision: 12, scale: 2
    add_column :stocks, :last_updated_time, :timestamp
  end
end
