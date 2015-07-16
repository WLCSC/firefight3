class Use < ActiveRecord::Base
  belongs_to :room
  belongs_to :consumable

  def user
    User.find(user_sid)
  end

end
