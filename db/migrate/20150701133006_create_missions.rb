class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.references :ticket, index: true, foreign_key: true
      t.string :user_sid

      t.timestamps null: false
    end
    add_index :missions, :user_sid
  end
end
