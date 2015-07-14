class CreateUses < ActiveRecord::Migration
  def change
    create_table :uses do |t|
      t.references :room, index: true, foreign_key: true
      t.references :consumable, index: true, foreign_key: true
      t.string :attachable_type
      t.string :attachable_id

      t.timestamps null: false
    end
  end
end
