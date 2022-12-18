# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

    def email_registered_admin_preview
        @recipient = Admin.new(username: "test.testing@kcl.ac.uk", admin_level: 2)
        AdminMailer.email_registered_admin(@recipient)
    end

    def email_deleted_admin_preview
        @recipient = Admin.new(username: "test.testing@kcl.ac.uk", admin_level: 2)
        AdminMailer.email_deleted_admin(@recipient)
    end

end
