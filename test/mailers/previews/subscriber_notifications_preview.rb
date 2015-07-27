# Preview all emails at http://localhost:3000/rails/mailers/subscriber_notifications
class SubscriberNotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscriber_notifications/new_ticket
  def new_ticket
    SubscriberNotifications.new_ticket
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscriber_notifications/updated_ticket
  def updated_ticket
    SubscriberNotifications.updated_ticket
  end

end
