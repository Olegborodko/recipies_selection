class EmailUserCreateJob < ApplicationJob
  queue_as :default

  def perform(email, rid)
    UserMailer.create(email, rid).deliver_now
  end
end
