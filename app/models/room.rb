class Room < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :uses
  has_many :stocks
  belongs_to :building

  validates :name, presence: true

  def nice_name
    "#{building.short}/#{name}"
  end

  def assets
    Asset.where(targetable_type: 'Room', targetable_id: id)
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
