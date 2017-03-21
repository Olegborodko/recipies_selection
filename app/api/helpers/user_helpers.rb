module UserHelpers

    def api_helper_authentication(email, password)
      if email && password
        user = User.find_by email: email.downcase
        if user
          if user.authenticate(password) && !unauthorized?(user.role_id)
            user
          end
        end
      end
    end

end