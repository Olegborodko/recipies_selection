module Users

  class ApiUsersController < Api
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
    end

    before do

    end

    resource :sessions do

    end

    resource :users do
      before do

      end

      ####################################POST api/users
      desc 'Create a new user', {
        is_array: true,
        success: Entities::UserCreate,
        failure: [{ code: 400, message: 'Invalid parameter entry' }]
      }

      params do
        requires :user, type: Hash do
          requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'users email'
          requires :name, type: String, desc: 'users name'
          requires :password, type: String, desc: 'users password'
          requires :password_confirmation, type: String, desc: 'users password confirmation'
          optional :description, type: String, desc: 'users description'
        end
      end

      post do
        #User.delete_all
        user = User.new(declared(params, include_missing: false)[:user])

        if user.save
          #path = Rails.application.routes.url_helpers.root_url + 'api/users/verification/' + token(user.rid)
          #EmailUserCreateJob.perform_later(user.email, path)
          present user, with: Entities::UserCreate, message: 'Please use token in 24 hours', token: token(user.rid)
          ##{ user: user, message: "success, please check your email" }
        else
          status 400
          { errors: user.errors }
        end
      end


      #########################################GET /api/users/verification
      desc 'User verification', {
        is_array: true,
        success: { massage: 'authorized' },
        failure: [{ code: 400, message: 'Invalid key' }]
      }

      params do
        requires :id, desc: 'users token'
      end

      get 'verification/:id' do
        tok = Base64.strict_decode64(declared(params, include_missing: false)[:id])
        hmac_secret = 'autorization_secret_key_from_users08'

        begin
          decoded_token = JWT.decode tok, hmac_secret, true, { :algorithm => 'HS256' }
        rescue
          return { message: 'key is invalid' }
        end

        user = User.find_by rid: decoded_token[0]['key']

          if user
            time_now = Time.now

            if user.created_at + ENV['time_for_audentification'].to_i > time_now
              user.update_attribute(:role_id, 2)
              return { messages: 'authorized' }
            else
              user.destroy
              return { message: 'error time audentification' }
            end
          end
          { message: 'user not found' }
      end


      #########################################PATCH /api/users/:id
      desc 'User update', {
        is_array: true,
        success: Entities::UserCreate,
        failure: [{ code: 400, message: 'Invalid parameter entry' }]
      }

      params do
        requires :user, type: Hash do
          requires :description, type: String, desc: 'users description'
        end
      end

      #patch :custom_url do
      patch do
        #if @current_user.update_attribute(declared(params, include_missing: false)[:user])

      end


    end

    add_swagger_documentation
  end
end