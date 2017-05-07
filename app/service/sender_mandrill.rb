class SenderMandrill
  require 'mandrill'
  attr_reader :template_name, :template_content

  def initialize(template_name, template_content)
    @template_name = template_name
    @template_content = template_content
  end

  def send
    rezult=[]
    begin
      mandrill = Mandrill::API.new Rails.application.secrets.mandrill_key
      template_content = [{"name": "footer", "content": @template_content}]
      message = {
      subject: "Favorite recipes",
      from_name: "user admin@#{ENV["domain"]}",
      from_email: "admin@#{ENV["domain"]}",
      to: User.all.as_json(only: [:name, :email]),
      preserve_recipients: false,
      }
      async = false
      r = mandrill.messages.send_template @template_name, template_content, message, async
      rezult << r
      rezult << false
    rescue Mandrill::Error => error
      rezult << "A mandrill error occurred: #{error.class} - #{error.message}"
      rezult << true
    end
    rezult
  end

end