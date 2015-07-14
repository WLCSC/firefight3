class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.references :model, index: true, foreign_key: true
      t.references :consumable, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
