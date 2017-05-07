class DeleteDeprecatedUsersJob < ApplicationJob
  # CronUserDeleteJob
  queue_as :default

  def perform(*args)
    User.where(status: 'unauthorized').find_each do |user|
      user.destroy unless user.have_correct_time?
    end
  end

end
