class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :topic, index: true, foreign_key: true
      t.string :submitter_sid
      t.datetime :due
      t.integer :status

      t.timestamps null: false
    end
    add_index :tickets, :submitter_sid
  end
end
