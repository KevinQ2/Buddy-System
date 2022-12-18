class EnrollInCommunicationMailer < ApplicationMailer
    default from: ENV["email_username"]
    
    # Send registration link to Mentees
    def email_mentee_enroll_in(recipient, url)
        # Email can be split to get name and surname for personalisation
        @recipient = recipient
        @url_to_enroll = url 
        mail(to: @recipient, subject: "Buddy Scheme - Register as Mentee")
    end

    # Send registration link to Mentors
    def email_mentor_enroll_in(recipient, url)
        # Email can be split to get name and surname for personalisation
        @recipient = recipient
        @url_to_enroll = url 
        mail(to: @recipient, subject: "Buddy Scheme - Register as Mentor")
    end


end
