class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def matches?(request)
    if request.session[:user_id]
      user = User.find_by rid: request.session[:user_id]
      if user.role_id == 3
        true
      end
    end
  end

  include SessionHelper
end
