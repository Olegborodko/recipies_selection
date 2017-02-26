module SessionHelper

private
  def current_user
    @current_user ||= User.find_by rid: session[:user_id] if session[:user_id]
  end
end
