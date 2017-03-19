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

  def key_have
    if params[:key] == "key_for_another_sites"
      true
    end
  end

  def token(user_rid)
    hmac_secret = 'autorization_secret_key_from_users08'
    payload = {:key =>  user_rid}
    token = JWT.encode payload, hmac_secret, 'HS256'
    Base64.strict_encode64(token)
  end

end
