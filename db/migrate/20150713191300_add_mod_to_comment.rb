class AddModToComment < ActiveRecord::Migration
  def change
    add_column :comments, :mod, :boolean
  end
end
