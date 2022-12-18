# Preview all emails at http://localhost:3000/rails/mailers/communication_mailer
class CommunicationMailerPreview < ActionMailer::Preview
    
    def email_mailinglist_preview
        @recipient = MailingList.new(email: "testing@gmail.bla")
        @subject = "Testing preview"
        @content = "<h1>Testing preview</h1>"
        CommunicationMailer.email_mailinglist(@recipient, @subject, @content)
    end

end
