class Subscription < ActiveRecord::Base
  validates :user_sid, presence: true
  #validates :subscribable_id, uniqueness: {scope: :subscribable_type}
  validates :subscribable_type, presence: true

  def subscribable
    subscribable_type.constantize.find(subscribable_id)
  end
end
