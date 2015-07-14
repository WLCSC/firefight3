class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.string :slug
      t.string :icon

      t.timestamps null: false
    end
    add_index :topics, :slug
  end
end
