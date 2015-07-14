class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :tag
      t.string :vendor
      t.json :history
      t.string :serial
      t.date :purchase
      t.integer :cost
      t.string :name
      t.string :targetable_type
      t.string :targetable_id
      t.references :model, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :assets, :tag, unique: true
    add_index :assets, :vendor
  end
end
