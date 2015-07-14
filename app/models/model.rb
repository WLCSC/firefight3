class Model < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :consumers
  has_many :models, through: :consumers
  has_many :assets

  def name_with_manufacturer
    manufacturer + ' ' + name
  end
end
