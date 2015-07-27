class Building < ActiveRecord::Base
  extend FriendlyId
  has_many :rooms
  has_many :assignments
  belongs_to :storeroom, class_name: "Room"
  friendly_id :short
  validates :short, format: {with: /\A[A-Za-z0-9]+\z/}, presence: true
  validates :name, presence: true

  def users
    assignments.map{|a| a.user}
  end

  def nice_name
    name
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
