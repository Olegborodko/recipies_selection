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

end