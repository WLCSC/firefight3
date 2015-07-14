class AttachableFactory
  class << self
    def call params, user
      ticket = Ticket.find(params[:ticket_id])
      flash = {}
      case params[:commit]
      when 'Change Status'
        old = ticket.status
        ticket.status = params[:status]
        if ticket.save
          ticket.comment! "#{user.nice_name} changed the status of this ticket from #{Ticket::STATUS_CODES[old]} to #{Ticket::STATUS_CODES[ticket.status]}.", nil
          flash[:notice] = "OK"
        end

      when 'Add Comment'
        ticket.comment! params[:content], user, params[:mod]
        flash[:notice] = "OK"

      when 'Comment & Complete'
        ticket.comment params[:content], user
        old = ticket.status
        ticket.status = 1
        if ticket.save
          ticket.comment! "#{user.nice_name} changed the status of this ticket from #{Ticket::STATUS_CODES[old]} to #{Ticket::STATUS_CODES[ticket.status]}.", nil
          flash[:notice] = "OK"
        end

      when 'Change Topic'
        old = ticket.topic
        ticket.topic_id = params[:topic_id]
        if ticket.save
          ticket.comment! "#{user.nice_name} moved this ticket from #{old.name} to #{ticket.topic.name}.", nil
          flash[:notice] = "OK"
        end

      when /Tag (\w+)/
        r = case $1
        when 'Room'
          Room.find_by_name(params[:room_name].split('/')[1])
        when 'Building'
          Building.find_by_name(params[:building_name])
        when 'User'
          User.find(params[:user_sid])
        when 'Asset'
           Asset.find_by_tag(params[:asset_tag])
        when 'Service'
          Service.find_by_name(params[:service_name])
        when 'Group'
          Group.find(params[:group_sid])
        end
        Target.create(ticket_id: ticket.id, targetable_type: r.class.to_s, targetable_id: r.try(:samaccountname) || r.id)
        ticket.comment! "#{user.nice_name} tagged #{r.nice_name} in this ticket.", nil
        flash[:notice] = "OK"

      when 'Untag Object'
        t = Target.find(params[:target_id])
        tg = t.targetable
        t.delete
        ticket.comment! "#{user.nice_name} removed #{tg.nice_name} from this ticket.", nil
        flash[:notice] = "OK"

      when 'Assign Asset'
        asset = Asset.find_by_tag(params[:asset_tag])
        t = Target.find(params[:target_id])
        asset.targetable = t.targetable
        Target.create(ticket: ticket, targetable_type: 'Asset', targetable_id: asset.id)
        if asset.save
          ticket.comment! "#{user.nice_name} assigned #{asset.nice_name} to #{asset.targetable.nice_name}.", nil
          flash[:notice] = "OK"
        end

      when 'Assign User'
        m = Mission.new(ticket_id: ticket.id, user_sid: params[:user_sid])
        if m.save
          Target.create(ticket_id: ticket.id, targetable_type: 'User', targetable_id: m.user.samaccountname)
          ticket.comment! "#{user.nice_name} assigned #{m.user.nice_name} to this ticket.", nil
          flash[:notice] = "OK"
        end

      when 'Add Attachment'
        a = Attachment.new(attachable_id: ticket.id, attachable_type: 'Ticket', file: params[:file], user_sid: user.samaccountname)
        a.save
        flash[:notice] = "OK"

      when 'Unassign User'
        m = Mission.find(params[:mission_id])
        u = m.user
        m.delete
        ticket.comment! "#{user.nice_name} unassigned #{u.nice_name} from this ticket.", nil
        flash[:notice] = "OK"

      when 'Update Service'
        s = Service.find(params[:service_id])
        if s.broken_at && s.broken_at != s
          flash[:error] = "Can't set the status of an overriden service."
        else
          Target.create(ticket_id: ticket.id, targetable_type: 'Service', targetable_id: s.id)
          s.statuses.build(code: params[:code], note: params[:note]).save
          ticket.comment! "#{user.nice_name} updated #{s.nice_name} to #{Service::STATUS_CODES[s.code]}: #{s.note}", nil
          flash[:notice] = "OK"
        end

      when 'Add Step'
        s = ticket.steps.build(content: params[:content], status: 0)
        if s.save
          ticket.comment! "#{user.nice_name} added a new step: #{s.content}.", nil
          flash[:notice] = "OK"
        end

      when 'Add Alert'
        meta = {}
        a = Alert.new(content: params[:content], attachable_id: ticket.id, attachable_type: 'Ticket', user_sid: user.samaccountname)
        if params[:trigger].present?
          a.trigger = DateTime.new *params[:trigger].map{|k,v| v.to_i}
        end
        if params[:status].present?
          meta['wakeStatus'] = params[:status]
          ticket.status = -2
        end

        a.meta = meta
        if a.save
          ticket.save
          flash[:notice] = "OK"
        end
      end

      flash
    end
  end
end
