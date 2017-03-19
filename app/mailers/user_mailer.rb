class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.create.subject
  #

  def create(user_to, path)
    @path = path
    mail to: user_to, subject: "Registration confirmation"
  end

  def password_new(user_to, password)
    @password = password
    mail to: user_to, subject: "Password Restore"
  end
end
