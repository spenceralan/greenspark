class TransactionsBelongToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :user_id, :uuid
  end
end
