class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :url
      t.string :description
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :services, :name, unique: true
  end
end
