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

  def primary_room
    if k = attachables.keep_if{|k| k.is_a? Room}.first
      return k
    else
      if a = attachables.keep_if{|k| k.is_a? Asset}.first
        if a.targetable.is_a? Room
          return a.targetable
        else
          nil
        end
      else
        nil
      end
    end
  end

  def primary_building
    if primary_room
      primary_room.building
    else
      if k = attachables.keep_if{|b| b.is_a? Building}.first
        return k
      else
        if submitter.buildings.count == 1
          return submitter.buildings.first
        else
          nil
        end
      end
    end
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

  def notify_mods
    topic.mods.each do |sid|
      SubscriberNotifications.updated_ticket(id, sid).deliver_later
    end
  end

  def notify
    list = []
    targetables.each do |t|
      if t.is_a? Group
        t.members.each do |m|
          list << m.samaccountname
        end
      elsif t.is_a? User
        list << t.samaccountname
      elsif t.is_a? Room
        t.assets.each do |a|
          a.subscriptions.each do |s|
            lsit << s.user_sid
          end
        end
      end
      t.subscriptions.each do |s|
        list << s.user_sid
      end
    end
    list.uniq.each do |sid|
      SubscriberNotifications.updated_ticket(id, sid).deliver_later
    end
  end

  def notify_all
    list = []
    topic.mods.each do |sid|
      SubscriberNotifications.updated_ticket(id, sid).deliver_later
    end
    targetables.each do |t|
      if t.is_a? Group
        t.members.each do |m|
          list << m.samaccountname
        end
      elsif t.is_a? User
        list << t.samaccountname
        elsif t.is_a? Room
          t.assets.each do |a|
            a.subscriptions.each do |s|
              lsit << s.user_sid
            end
          end
      end
      t.subscriptions.each do |s|
        list << s.user_sid
      end
    end
    list.uniq.each do |sid|
      SubscriberNotifications.updated_ticket(id, sid).deliver_later
    end
  end
end
