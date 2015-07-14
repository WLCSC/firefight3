class Target < ActiveRecord::Base
  belongs_to :ticket
  validates :targetable_id, uniqueness: {scope: [:targetable_type, :ticket_id]}, presence: true
  validates :targetable_type, presence: true
  validates :ticket_id, presence: true

  def targetable
    targetable_type.constantize.find(targetable_id)
  end
end
