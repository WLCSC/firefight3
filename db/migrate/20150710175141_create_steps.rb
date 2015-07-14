class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :ticket_id
      t.text :content
      t.integer :status

      t.timestamps null: false
    end
  end
end
