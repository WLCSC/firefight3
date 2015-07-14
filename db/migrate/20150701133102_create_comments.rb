class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :attachable, polymorphic: true, index: true
      t.string :user_sid

      t.timestamps null: false
    end
    add_index :comments, :user_sid
  end
end
