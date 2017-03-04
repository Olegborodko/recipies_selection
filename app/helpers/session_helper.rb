module SessionHelper

  private
  def current_user
    @current_user ||= User.find_by rid: session[:user_id] if session[:user_id]
  end

  def authentication(email, password) #nil or session
    if email && password
      user = User.find_by email: email.downcase
      if user && user.authenticate(password)
        session[:user_id] = user.rid
      end
    end
  end

  #def authorize
  #  redirect_to root_url unless current_user
  #end
end
