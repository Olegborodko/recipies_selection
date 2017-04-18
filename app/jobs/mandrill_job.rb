class MandrillJob < ApplicationJob
  queue_as :default

  def perform(template_name, template_content)
    s = SenderMandrill.new(template_name, template_content).send
    EmailLogger.new("mandrill.log", s[0], s[1]).save
  end

end
