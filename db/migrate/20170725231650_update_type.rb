class UpdateType < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :type
    add_column :transactions, :trade_type, :string
  end
end
