module UsersApi

  class ApiUsersController < Grape::API
    prefix :api
    version 'v1'
    format :json

    helpers SessionHelper

    before do

    end

    resource :sessions do

    end

    resource :users do
      before do

      end

      #params
      params do
        requires :user, type: Hash do
          requires :email, allow_blank: false, regexp: /.+@.+/
          requires :name, type: String
          requires :password, type: String
          requires :password_confirmation, type: String
          optional :description, type: String
        end
      end

      #POST api/v1/users
      post do
        user = User.new(declared(params, include_missing: false)[:user])

        if user.save
          EmailUserCreateJob.perform_later(user.email, user.rid)
          status 200
          { user: user, message: "success, please check your email" }
        else

          { errors: user.errors,  status: :unprocessable_entity }
        end
      end
    end

    add_swagger_documentation
  end
end