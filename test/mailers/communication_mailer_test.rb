require 'test_helper'

class CommunicationMailerTest < ActionMailer::TestCase
  
  def setup
    newRecipient = MailingList.new(:email => "schemebuddy@gmail.com")
    newRecipient.save
    @recipient = newRecipient
    @subject = "Testing"
    @content = "Testing and checking"
  end

  test 'commmunication email_mailinglist' do
    email = CommunicationMailer.email_mailinglist(@recipient, @subject, @content)
    assert_emails 1 do 
      email.deliver_later
    end

    assert_equal email.to, [@recipient.email]
    assert_equal email.from, ["schemebuddy@gmail.com"]
    assert_equal email.subject, @subject
    assert_match "Testing and checking", email.body.encoded
  end

  test 'commmunication email_mailingusers' do
    recipient_email = "schemebuddy@gmail.com"
    email = CommunicationMailer.email_mailingusers(recipient_email, @subject, @content)
    assert_emails 1 do 
      email.deliver_later
    end

    assert_equal email.to, [recipient_email]
    assert_equal email.from, ["schemebuddy@gmail.com"]
    assert_equal email.subject, @subject
    assert_match "Testing and checking", email.body.encoded
  end

end
