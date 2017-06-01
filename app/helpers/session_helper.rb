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
    params[:key] == 'key_for_another_sites'
  end

  def token_create(user)
    user.update_attribute(:token, user.token_generate)
    token_encode(user)
  end

  def token_encode(user)
    payload = { key: user.rid, label: user.token }
    token = JWT.encode payload, ENV['token_secret_key'], 'HS256'

    Base64.strict_encode64(token)
  end

  def get_user_from_token(token)
    begin
      tok = Base64.strict_decode64(token)
      decoded_token = JWT.decode tok, ENV['token_secret_key'], true, { algorithm: 'HS256' }
    rescue
      nil
    else
      user = User.find_by rid: decoded_token.first['key']
      if user
        user if user.token == decoded_token.first['label']
      else
        nil
      end
    end
  end

  def password_generate
    password_func(('a'..'z'), 5) +
    password_func(('A'..'Z'), 5) +
    password_func((0..9),5)
  end

  def password_func(x, l)
    o = [x].map(&:to_a).flatten
    (0...rand(2..l)).map { o[rand(o.length)] }.join
  end

end
