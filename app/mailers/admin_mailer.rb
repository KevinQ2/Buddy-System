class AdminMailer < ApplicationMailer
    default from: ENV["email_username"]

    def email_registered_admin(recipient)
        @admin = recipient
        # Login url (saved in environment variable) attached in email for admin to login
        @loginUrl = ENV["admin_login_url"]
        mail(to: @admin.username, subject: "You are registered on KCL Buddy Scheme")
    end

    def email_deleted_admin(recipient)
        @admin = recipient
        mail(to: @admin.username, subject: "You are deleted from KCL Buddy Scheme") 
    end

end
