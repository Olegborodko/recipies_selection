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
    user.admin? if user
  end

  def user_is_allowed(user)
    if user
      true unless user.unauthorized? || user.ban?
    end
  end

  def users_token
    params[:api_key] if params[:api_key]
  end

end