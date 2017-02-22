class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.create.subject
  #
  def create
    @greeting = "Hi"

    mail to: "220v2@mail.ru", subject: "subject_test"
  end
end
