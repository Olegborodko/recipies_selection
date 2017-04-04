module SessionHelper

  private
  def current_user
    @current_user ||= User.find_by rid: session[:user_id] if session[:user_id]
  end

  def authentication(email, password) #nil or session
    if email && password
      user = User.find_by email: email.downcase
      if user && user.authenticate(password) && !user.unauthorized?
        session[:user_id] = user.rid
      end
    end
  end

  def key_have
    if params[:key] == "key_for_another_sites"
      true
    end
  end

  def token_encode(user_rid)
    payload = {:key =>  user_rid}
    token = JWT.encode payload, ENV["token_secret_key"], 'HS256'
    Base64.strict_encode64(token)
  end

  def get_user_from_token(token)
    begin
      tok = Base64.strict_decode64(token)
      decoded_token = JWT.decode tok, ENV["token_secret_key"], true, { :algorithm => 'HS256' }
    rescue
      return nil
    else
      User.find_by rid: decoded_token[0]['key']
    end
  end

end
