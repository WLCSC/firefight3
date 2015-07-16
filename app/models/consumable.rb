class Consumable < ActiveRecord::Base
  has_many :stocks
  has_many :uses
  has_many :consumers
  has_many :models, through: :consumers
  before_save :set_model

  def count
    stocks.sum(:count)
  end
end
