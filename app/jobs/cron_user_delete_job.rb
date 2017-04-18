class CronUserDeleteJob < ApplicationJob
  queue_as :default

  def perform(*args)

    User.where(status: 'unauthorized').find_each do |user|
      if user.created_at + User.time_for_authentification < Time.now
        user.destroy
      end
    end
  end
end
