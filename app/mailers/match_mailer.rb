class MatchMailer < ApplicationMailer
    default from: ENV["email_username"]
    

    # Send infromational email to mentee about the match, his mentor
    def inform_mentee_match(recipient, mentor)
        
        @mentor = mentor
        @recipient = recipient

        mail(to: @recipient, subject: "Buddy Scheme - About your mentor!")
    end

    # Send infromational email to mentor about the match, his mentee
    def inform_mentor_match(recipient, mentee)
        
        @mentee = mentee
        @recipient = recipient

        mail(to: @recipient, subject: "Buddy Scheme - About your mentee!")
    end


end
