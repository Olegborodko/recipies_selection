class MandrillJob < ApplicationJob
  queue_as :default

  def perform(template_name, template_content)
    s = SenderMandrill.new(template_name, template_content).call
    SaveToLog.new('mandrill.log', s[:body] , s[:success]).save
  end

end
