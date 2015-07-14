class Permission < ActiveRecord::Base
  VALUES = {1 => "Submit Tickets", 2 => 'Read & Comment on Tickets', 100 => "Moderate Topic"}
  belongs_to :topic
  validates :level, presence: true, inclusion: VALUES.keys
  validates_associated :topic

  def listable
    User.find(:first, listable_sid) || Group.find(:first, listable_sid)
  end

  def users
    if listable.is_a? Group
      listable.members
    else
      [listable]
    end
  end
end
