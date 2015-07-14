class Assignment < ActiveRecord::Base
  belongs_to :building
  validates :user_sid, presence: true, uniqueness: {scope: :building_id}
  validates_associated :building


  def user
    User.find(:first, user_sid)
  end
end
