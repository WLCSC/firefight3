class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :short
      t.integer :storeroom_id

      t.timestamps null: false
    end
    add_index :buildings, :name, unique: true
    add_index :buildings, :short, unique: true
    add_index :buildings, :storeroom_id
  end
end
