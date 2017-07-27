class AddIncremental < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :incremental, :decimal, precision: 12, scale: 2
  end
end
