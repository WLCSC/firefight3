class Asset < ActiveRecord::Base
  extend FriendlyId
  friendly_id :tag
  belongs_to :model
  validates :tag, presence: true, uniqueness: true
  validates :serial, presence: true
  validates :vendor, presence: true
  validates :purchase, presence: true
  validates :cost, presence: true, numericality: true
  attr_accessor :model_n
  before_save :set_model

  def set_model
    self.model = Model.where('name ILIKE ?', model_n).first if model_n.present?
  end

  def targetable
    if targetable_type && targetable_id
    targetable_type.constantize.find(targetable_id)
    else
      nil
    end
  end

  def ping
    if name && c = Computer.find(:first, name)
      c.ping
    else
      nil
    end
  end

  def targetable= t
      self[:targetable_type] = t.class.to_s
      self[:targetable_id] = t.try(:samaccountname) || t.id
  end

  def nice_name
    name.present? ? name : "#"+tag
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
