class CreateConsumables < ActiveRecord::Migration
  def change
    create_table :consumables do |t|
      t.string :name
      t.string :short
      t.string :barcode

      t.timestamps null: false
    end
    add_index :consumables, :short, unique: true
    add_index :consumables, :barcode, unique: true
  end
end
