class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.references :building, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :rooms, :name
    add_index :rooms, :slug, unique: true
    add_foreign_key :buildings, :rooms, column: :storeroom_id
  end
end
