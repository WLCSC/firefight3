class AddTargetsToConsumable < ActiveRecord::Migration
  def change
    add_column :consumables, :target, :integer
    add_column :consumables, :hard, :integer
    add_column :consumables, :soft, :integer
  end
end
