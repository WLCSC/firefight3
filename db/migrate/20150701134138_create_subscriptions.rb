class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :user_sid
      t.references :subscribable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :subscriptions, :user_sid
  end
end
