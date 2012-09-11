require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "verification" do
    mail = Notifier.verification
    assert_equal "Verification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "notification" do
    mail = Notifier.notification
    assert_equal "Notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
