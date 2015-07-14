class Mission < ActiveRecord::Base
  belongs_to :ticket
  validates :user_sid, uniqueness: {scope: :ticket_id}

  def user
    User.find(user_sid)
  end

  def user= u
    if u.is_a? String
      user_sid = User.find(u).samaccountname
    else
      user_sid = u.samaccountname
    end
  end
end
