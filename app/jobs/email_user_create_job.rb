class EmailUserCreateJob < ApplicationJob
  queue_as :default

  def perform(email, path)
    UserMailer.create(email, path).deliver_now
  end
end
