class SubscriberNotifications < ApplicationMailer
  def new_ticket(ticket_id, user_sid)
    @ticket = Ticket.find(ticket_id)
    @user = User.find(user_sid)

    mail to: @user.mail, subject: "Ticket ##{@ticket.id}"
  end

  def updated_ticket(ticket_id, user_sid)
    @ticket = Ticket.find(ticket_id)
    @user = User.find(user_sid)

    mail to: @user.mail, subject: "Re: Ticket ##{@ticket.id}"
  end
end
