require 'test_helper'

class SubscriberNotificationsTest < ActionMailer::TestCase
  test "new_ticket" do
    mail = SubscriberNotifications.new_ticket
    assert_equal "New ticket", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "updated_ticket" do
    mail = SubscriberNotifications.updated_ticket
    assert_equal "Updated ticket", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
