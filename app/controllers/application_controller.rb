class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def matches?(request)
    if request.session[:user_id]
      user = User.find_by rid: request.session[:user_id]
      if user
        user.admin?
      end
    end
  end

  include SessionHelper

  private

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

end
