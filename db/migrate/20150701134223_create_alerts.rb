class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :attachable, polymorphic: true, index: true
      t.text :content
      t.datetime :trigger
      t.json :meta

      t.timestamps null: false
    end
  end
end
