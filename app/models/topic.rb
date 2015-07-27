class Topic < ActiveRecord::Base
  has_many :permissions
  has_many :tickets
  validates :name, presence: true
  validates :icon, presence: true, inclusion: FONT_AWESOME_ICONS

  def nice_name
    name
  end

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

  def mods
    list = []
    permissions.where('level > 90').each do |p|
      list += p.users.map(&:samaccountname)
    end
    list.uniq
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
