class ChangeTradeTypeToEnum < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :trade_type, :string
    add_column :transactions, :trade_type, :integer, default: 0
  end
end
