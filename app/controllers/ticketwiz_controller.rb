class TicketwizController < ApplicationController
  before_action :check_for_user
  def topic
    @topics = current_user.topics
    if params[:targetable_type].present?
      @type = params[:targetable_type]
      if params[:targetable].present?
        @targetable = TargetableFinder.call(params[:targetable_type], params[:targetable])
      end
    end
  end

  def target
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
    end
    if params[:targetable_type].present?
      redirect_to wiz_ticket_path(targetable_type: params[:targetable_type], topic_id: @topic.id)
    end
  end

  def ticket
    @topic = Topic.find(params[:topic_id])
    @type = params[:targetable_type]
    @ticket = Ticket.new(topic: @topic, submitter: current_user, status: 20)
    @ticket.targetable = TargetableFinder.call(params[:targetable_type], params[:targetable])
    if @type == 'user'
      @ticket.targetable = current_user
    end
  end

  def submit
    @ticket = Ticket.new(topic_id: params[:topic_id], status: params[:status], comment: params[:comment], targetable: TargetableFinder.call(params[:targetable_type], params[:targetable]))
    @ticket.submitter_sid = current_user.samaccountname
    if params[:due].present?
      @ticket.due = DateTime.new *params[:due].map{|k,v| v.to_i}
    end
    if @ticket.save
      @ticket.notify_all
      redirect_to @ticket
    else
      @ticket.errors.full_messages.each do |e|
        flash.now[:alert] = e.to_s
      end
      @topic = Topic.find(params[:topic_id])
      @type = params[:targetable_type]
      render 'ticket'
    end
  end
end
