class Consumable < ActiveRecord::Base
  has_many :stocks
  has_many :uses
  has_many :consumers
  has_many :models, through: :consumers
  before_save :set_model

  def count
    stocks.sum(:count)
  end

  def nice_name
    "#{name}/#{short}"
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
