class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.string :slug
      t.string :manufacturer
      t.string :category

      t.timestamps null: false
    end
    add_index :models, :manufacturer
    add_index :models, :category
    add_index :models, :name, unique: true
    add_index :models, :slug, unique: true
  end
end
