class CreateClosingPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :closing_prices, id: :uuid do |t|
      t.uuid :ticker_id
      t.date :date
      t.decimal :price, precision: 12, scale: 2
      t.timestamps
    end
  end
end
