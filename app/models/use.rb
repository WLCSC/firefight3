class Use < ActiveRecord::Base
  belongs_to :room
  belongs_to :consumable

  def user
    User.find(user_sid)
  end

  def content
    "#{user.nice_name} used #{consumable.name} from #{room.nice_name}."
  end
end
