class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :code
      t.string :note
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
