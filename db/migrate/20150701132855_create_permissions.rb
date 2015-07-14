class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :listable_sid
      t.references :topic, index: true, foreign_key: true
      t.integer :level

      t.timestamps null: false
    end
    add_index :permissions, :listable_sid
  end
end
