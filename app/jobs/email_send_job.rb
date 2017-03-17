class EmailSendJob < ApplicationJob
  queue_as :default

  def perform(email, p_new)
    # Do something later
    UserMailer.password_new(email, p_new).deliver_now
  end
end
