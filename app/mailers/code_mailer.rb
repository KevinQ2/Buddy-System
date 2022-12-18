class CodeMailer < ApplicationMailer
  #default from: ENV["email_username"]
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.code_mailer.new_code.subject
  #
  def new_code(number,email)
    @code = number
    @email = email
    mail(to: @email, subject:"Your Buddy Scheme Verification Code")
  end
end
