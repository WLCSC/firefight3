class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :user_sid
      t.references :building, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :assignments, :user_sid
  end
end
