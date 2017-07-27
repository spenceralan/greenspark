class AddTotal < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :total, :decimal, precision: 12, scale: 2
  end
end
