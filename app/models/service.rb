class Service < ActiveRecord::Base
  STATUS_CODES = {1 => 'Available', 10 => 'Unavailable (Maintenance)', 11 => 'Unavailable (Unplanned)', 20 => 'Intermittent', 0 => 'Unknown'}
  belongs_to :service
  has_many :services
  has_many :statuses

  scope :top_level, -> {where(service_id: nil)}

  def code
    status.code
  end

  def note
    status.note
  end

  def parent
    service
  end

  def children
    services
  end

  def ancestors
    if parent
      parent.ancestors
    else
      [self]
    end
  end

  def root
    if parent
      parent.root
    else
      self
    end
  end

  def broken_at
    if code != 1
      ancestors.each do |a|
        if a.code != 1
          return a
        end
      end
      self
    else
      nil
    end
  end

  def ancestral_statuses
    Status.where(:service_id => ancestors.map{|s| s.id}).order('created_at DESC')
  end

  def children_list
    if children.count > 0
      children.to_a.map{|c| c.children_list}
    else
      [self]
    end.flatten
  end

  def status
    if parent && parent.status != 1
      parent.status
    else
      if statuses.count > 0
        statuses.last
      else
        statuses.build(code: 1, note: "All is well.")
      end
    end
  end

  def tickets
    ids = Target.where(targetable_type: 'Service', targetable_id: (children.map(&:id) + [id])).map{|t| t.ticket.id}
    Ticket.where(id: ids.uniq)
  end

  def nice_name
    name
  end

  def overridden?
    parent && (parent.overridden? || parent.status != 1) || false
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
