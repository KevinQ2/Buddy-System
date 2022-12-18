class CommunicationMailer < ApplicationMailer
    default from: ENV["email_username"]
    
    # Used for imported mailing list email
    def email_mailinglist(recipient, subject, content)
        @recipient = recipient
        @content = content.html_safe
        mail(to: @recipient.email, subject: subject)
    end

    # Used to email registered users
    def email_mailingusers(email, subject, content)
        mail(to: email, subject: subject)
    end
end
