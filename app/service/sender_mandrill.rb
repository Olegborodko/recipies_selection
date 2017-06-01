class SenderMandrill
  require 'mandrill'
  attr_reader :template_name, :txt

  def initialize(template_name, txt)
    @template_name = template_name
    @template_body = txt
  end

  def call
    result = {}
    begin
      send_message = mandrill.messages.send_template @template_name,
                     template_content, message, false
      result[:body] = send_message
      result[:success] = true
    rescue Mandrill::Error => error
      result[:body] = "A mandrill error occurred: #{error.class} - #{error.message}"
      result[:success] = false
    end
    result
  end

  private

  def mandrill
    @mandrill ||= Mandrill::API.new Rails.application.secrets.mandrill_key
  end

  def message
    {
    subject: 'Favorite recipes',
    from_name: "user admin@#{ENV['domain']}",
    from_email: "admin@#{ENV['domain']}",
    to: User.all.as_json(only: [:name, :email]), #all users
    preserve_recipients: false
    }
  end

  def template_content
    [{ 'name': 'footer', 'content': @template_body}]
  end

end