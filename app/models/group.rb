class Group < ActiveLdap::Base
  ldap_mapping dn_attribute: 'name', classes: ['top', 'group'], prefix: '', scope: :sub

  def nice_name
    name
  end

  def members
    list = []
    member(true).each do |m|
      x = SidFinder.call m
      if x
        if x.is_a? User
          list << x
        else
          list.merge x.members
        end
      end
    end
    list
  end

  def tickets
    ids = Target.where(targetable_type: 'Group', targetable_id: name).map{|t| t.ticket.id}
    ids += Target.where(targetable_type: 'User', targetable_id: members.map(&:samaccountname))
    Ticket.where(id: ids.uniq)
  end

  def subscriptions
    Subscription.where(subscribable_type: self.class.to_s, subscribable_id: id)
  end
end
