class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :count
      t.references :consumable, index: true, foreign_key: true
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
