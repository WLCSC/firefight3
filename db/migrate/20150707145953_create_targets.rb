class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.integer :ticket_id
      t.string :targetable_type
      t.string :targetable_id

      t.timestamps null: false
    end
  end
end
