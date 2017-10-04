class CreateTickers < ActiveRecord::Migration[5.1]
  def change
    create_table :tickers, id: :uuid do |t|
      t.string :symbol
      t.decimal :last_updated_price, precision: 12, scale: 2
      t.datetime :last_updated_time

      t.timestamps
    end
    add_column :stocks, :ticker_id, :uuid
    remove_column :stocks, :last_updated_price, :decimal, precision: 12, scale: 2
    remove_column :stocks, :last_updated_time, :datetime
    Stock.find_each(&:save!)
  end
end
