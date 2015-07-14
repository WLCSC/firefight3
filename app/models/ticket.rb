class Ticket < ActiveRecord::Base
  STATUS_CODES = {0 => "Low", -1 => "Deferred", -2 => "Sleeping", 1 => 'Complete', 10 => 'Urgent', 20 => 'Routine'}
  belongs_to :topic
  has_many :missions, dependent: :destroy
  has_many :targets, dependent: :destroy
  has_many :steps, dependent: :destroy
  attr_accessor :comment, :targetable
  validates :status, presence: true
  validates :comment, presence: true, on: :create
  validates :targetable, presence: true, on: :create
  after_create :create_submodels

  STATUS_CODES.each_pair do |v, l|
    scope l.downcase.gsub(/\W/,'_'), -> {where(status: v)}
  end
  scope 'incomplete', -> {where.not(status: 1)}

  def create_submodels
    Comment.create(content: self.comment, attachable_id: id, attachable_type: 'Ticket', user_sid: submitter_sid)
    Target.create(ticket_id: id, targetable_type: targetable.class.to_s, targetable_id: targetable.try(:samaccountname) || targetable.id)
    Target.create(ticket_id: id, targetable_type: 'User', targetable_id: submitter_sid)
  end

  def closable?
    steps.count == 0 || (steps.count > 0 && steps.map(&:status).delete_if{|x| x == 1}.count == 0)
  end

  def nice_name
    "##{id}"
  end

  def attachables
    [Comment, Attachment, Alert, Use].map do |klass|
      klass.where(attachable_id: id, attachable_type: 'Ticket')
    end.flatten.sort{|a,b| a.created_at <=> b.created_at}
  end

  def comments
    Comment.where(attachable_id: id, attachable_type: 'Ticket').order(:created_at)
  end

  def comment! content, user, mod=false
    Comment.create(attachable_id: id, attachable_type: 'Ticket', user_sid: user.try(:samaccountname), content: content, mod: mod.present?)
  end

  def targetables
    targets.map{|t| t.targetable}
  end

  def submitter
    User.find(submitter_sid)
  end

  def submitter= u
    if u.is_a? String
      submitter_sid = u
    else
      submitter_sid = u.samaccountname
    end
  end
end
