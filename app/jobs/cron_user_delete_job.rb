class CronUserDeleteJob < ApplicationJob
  queue_as :default

  def perform(*args)

    time_now = Time.now
    User.where(role_id: 1).find_each do |user|
      if user.created_at + ENV['time_for_audentification'].to_i < time_now
        user.destroy
      end
    end
  end
end
