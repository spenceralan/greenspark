class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :type
      t.decimal :price, precision: 12, scale: 2
      t.integer :quantity
      t.date :date
      t.uuid :stock_id

      t.timestamps
    end
  end
end
