class TicketFilter
  class << self
    def call params, user
      topics = user.read_topics.map(&:id)
      topicTickets = Ticket.where(topic_id: topics).pluck(:id)
      tickets = user.tickets.map(&:id) + topicTickets
      @tickets = Ticket.where(id: tickets)
      @tickets = @tickets.where(topic_id: params[:topic_id]) if params[:topic_id].present?
      @tickets = @tickets.where(status: params[:status]) if params[:status].present? && params[:status] != 'i'
      @tickets = @tickets.where.not(status: 1) if params[:status].present? && params[:status] == 'i'
      @tickets = @tickets.where('submitter_ ILIKE ?', params[:submitter]) if params[:submitter].present?
      if params[:assigned_sid].present?
        missions = Mission.where(user_sid: params[:assigned_sid])
        @tickets = @tickets.where(id: missions.map(&:ticket_id))
      end
      if params[:user_sid].present?
        targets = Target.where(targetable_id: params[:user_sid], targetable_type: 'User')
        @tickets = @tickets.where(id: targets.map(&:ticket_id))
      end
      if params[:group_sid].present?
        targets = Target.where(targetable_id: params[:group_sid], targetable_type: 'Group')
        @tickets = @tickets.where(id: targets.map(&:ticket_id))
      end
      if params[:asset_tag].present?
        a = Asset.find_by_tag(params[:asset_tag])
        targets = Target.where(targetable_id: a.id, targetable_type: 'Asset')
        @tickets = @tickets.where(id: targets.map(&:ticket_id))
      end
      if params[:service_name].present?
        s = Service.find_by_name(params[:service_name])
        targets = Target.where(targetable_id: s.id, targetable_type: 'Service')
        @tickets = @tickets.where(id: targets.map(&:ticket_id))
      end
      @tickets = @tickets.order(:id)

      if params[:associated_room].present?
        r = Room.find_by_name(params[:associated_room].split('/')[1])
        t = Target.where(targetable_type: 'Room', targetable_id: r.id).to_a
        aids = Asset.where(targetable_type: 'Room', targetable_id: r.id).map(&:id)
        t.concat Target.where(targetable_type: 'Asset', targetable_id: aids)
        @tickets = @tickets.where(id: t.flatten.map(&:ticket_id))
      end

      if params[:associated_building].present?
        b = Building.find_by_short(params[:associated_building])
        t = Target.where(targetable_type: 'Building', targetable_id: b.id).to_a
        rids = Room.where(building_id: b.id).map(&:id)
        t.concat Target.where(targetable_type: 'Room', targetable_id: rids)
        aids = Asset.where(targetable_type: 'Room', targetable_id: rids).map(&:id)
        t.concat Target.where(targetable_type: 'Asset', targetable_id: aids)
        baids = Asset.where(targetable_type: 'Building', targetable_id: b.id).map(&:id)
        t.concat Target.where(targetable_type: 'Asset', targetable_id: baids)
        @tickets = @tickets.where(id: t.flatten.map(&:ticket_id))
      end

      @tickets.order(:id)
    end
  end
end
