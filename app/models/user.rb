require 'set'
class User < ActiveLdap::Base
  ldap_mapping dn_attribute: 'sAMAccountName', classes: ['top', 'organizationalPerson', 'person', 'user'], excluded_classes: ['computer'], prefix: '', scope: :sub

  def nice_name
    begin
    givenName + ' ' + sn
    rescue
      'ERR'
    end
  end

  def membership
    @membership ||= Group.find(:all, filter: {member: dn})
  end

  def submitted_tickets
    Ticket.where(submitter_sid: sAMAccountName)
  end

  def tagged_tickets
    targets = Target.where(targetable_type: 'User', targetable_id: sAMAccountName)
    Ticket.where(id: targets.map(&:ticket_id))
  end

  def assigned_tickets
    missions = Mission.where(user_sid: sAMAccountName)
    Ticket.where(id: missions.map(&:ticket_id))
  end

  def groups(force=false)
    if !@groups || force
      processed = Set.new
      list =  membership
      while !list.empty?
        x = list.pop
        Group.find(:all, filter: {member: x.dn}).each do |m|
          y = Group.find(:first, m.sAMAccountName)
          list << y if y
        end
        processed << x
      end
      @groups = processed.to_a
    else
      @groups
    end
  end

  def mod?
    Topic.all.map{|t| t.level_for self}.keep_if{|l| l > 90}.count > 0
  end

  def admin?
    groups.include?(Group.find(:first, APP_CONFIG[:admin_group]))
  end

  def buildings
    Assignment.where(:user_sid => samaccountname).map{|a| a.building}
  end

  def topics
    Topic.all.to_a.keep_if{|t| t.level_for(self) > 0}
  end

  def read_topics
    Topic.all.to_a.keep_if{|t| t.level_for(self) > 1}
  end

  def mod_topics
    Topic.all.to_a.keep_if{|t| t.level_for(self) > 90}
  end

  def tickets
    Ticket.where(id: Target.where(targetable_type: 'User', targetable_id: samaccountname).map(&:ticket_id))
  end

  def User.authenticate(sid, password)
    user = User.find(sid)
    user.bind(password)
    user
  end
end
