class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks, id: :uuid do |t|
      t.string :symbol
      t.string :name
      t.string :description
      t.string :exchange

      t.timestamps
    end
  end
end
