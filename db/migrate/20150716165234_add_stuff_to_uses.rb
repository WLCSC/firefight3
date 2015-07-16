class AddStuffToUses < ActiveRecord::Migration
  def change
    add_column :uses, :user_sid, :string
  end
end
