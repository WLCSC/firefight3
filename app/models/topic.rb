class Topic < ActiveRecord::Base
  has_many :permissions
  has_many :tickets
  validates :name, presence: true
  validates :icon, presence: true, inclusion: FONT_AWESOME_ICONS

  def level_for user
    go = 0
    unless user.is_a? User
      unless user = User.find(:first, user)
        return 0
      end
    end
    permissions.each do |p|
      if p.listable.is_a? Group
        if user.groups.include? p.listable
          go = p.level unless go > p.level
        end
      else
        if p.listable.dn.to_s == user.dn.to_s
          go = p.level unless go > p.level
        end
      end
    end
    go
  end
end
