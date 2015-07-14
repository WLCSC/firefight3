class Alert < ActiveRecord::Base
  def user
    begin
    User.find(user_sid)
    rescue
      nil
    end
  end
end
