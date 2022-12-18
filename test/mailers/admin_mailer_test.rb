require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase

  def setup
    newRecipient = admins(:superadmin)
    @recipient = newRecipient
  end

  test "test admin mailer email registered admin" do
    email = AdminMailer.email_registered_admin(@recipient)
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@recipient.username]
    assert_equal email.from, ["schemebuddy@gmail.com"]
    assert_equal email.subject, "You are registered on KCL Buddy Scheme"
  end

  test "test admin mailer email deleted admin" do
    email = AdminMailer.email_deleted_admin(@recipient)

    assert_emails 1 do
      email.deliver_later
    end

     assert_equal email.to, [@recipient.username]
     assert_equal email.from, ["schemebuddy@gmail.com"]
     assert_equal email.subject, "You are deleted from KCL Buddy Scheme"
   end

end
