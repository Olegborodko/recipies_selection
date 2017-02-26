class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.create.subject
  #
  def create(user_to, user_rid)
    hmac_secret = 'autorization_secret_key_from_users08'
    t = Time.now
    t += (60 * 60 * 24) #sec
    payload = {:time => t,
               :key =>  user_rid}

    @token = JWT.encode payload, hmac_secret, 'HS256'

    mail to: user_to, subject: "Registration confirmation"
  end
end
