module UserHelpers

  def api_helper_authentication(email, password)
    if email && password
      user = User.find_by email: email.downcase
      if user
        if user.authenticate(password) && !user.unauthorized?
          user
        end
      end
    end
  end

  def all_params_hash
    declared(params, include_missing: false).to_hash
  end

  def user_admin?(user)
    false
    if user
      if user.admin?
        true
      end
    end
  end

  def user_is_allowed(user)
    if user
      return false if user.unauthorized?
      return false if user.ban?
      true
    else
      false
    end
  end

  def users_token
    params[:api_key] if params[:api_key]
  end

end