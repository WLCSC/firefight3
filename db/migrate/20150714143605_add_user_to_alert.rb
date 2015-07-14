class AddUserToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :user_sid, :string
  end
end
