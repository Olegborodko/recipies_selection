module Modules

  class UsersPart < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    resource :users do

      ###POST api/users
      desc 'Create a new user', {
      is_array: true,
      success: { code: 201, model: Entities::UserCreate },
      failure: [{ code: 406, message: 'Parameters contain errors' }]
      }
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'users email'
        requires :name, type: String, desc: 'users name'
        requires :password, type: String, desc: 'users password'
        requires :password_confirmation, type: String, desc: 'users password confirmation'
        optional :description, type: String, desc: 'users description'
      end
      post do
        user = User.new(all_params_hash)
        if user.save
          path = token_encode(user.rid)
          EmailUserCreateJob.perform_later(user.email, path)
          present user, with: Entities::UserCreate, message: 'Please use token in 24 hours, else user will delete', token: token_encode(user.rid)
        else
          status 406
          { errors: user.errors }
        end
      end

      ###GET /api/users/verification
      desc 'User verification', {
      is_array: false,
      success: { massage: 'authorized' },
      failure: [{ code: 401, message: 'Invalid key' },
                { code: 406, message: 'Error time authentification' }]
      }
      params do
        #requires :user_token, desc: 'users token'
      end
      get 'verification' do
        if @current_user
          if @current_user.unauthorized?
            if @current_user.created_at + User.time_for_authentification > Time.now
              @current_user.status = "subscriber"
              @current_user.save(validate: false)
              return { messages: 'authorized' }
            else
              @current_user.destroy
              status 406
              return { error: 'error time authentification' }
            end
          end
        end
        status 401
        { error: 'Invalid key' }
      end

      ##POST /api/users/login
      desc 'User login', {
      is_array: true,
      success: { massage: 'login success' },
      failure: [{ code: 406, message: 'Not correct password or email' }]
      }
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'users email'
        requires :password, type: String, desc: 'users password'
      end
      post :login do
        user = api_helper_authentication(params[:email],params[:password])
        if user
          { token: token_encode(user.rid), message: 'login success' }
        else
          status 406
          { error: 'Not correct password or email' }
        end
      end

      ##PATCH /api/users
      desc 'User update', {
      is_array: true,
      success: Entities::UserBase,
      failure: [{ code: 406, message: 'Invalid parameter entry' }]
      }
      params do
        requires :description, type: String, desc: 'users description'
      end
      patch do
        if user_is_allowed @current_user
          @current_user.update_attribute(:description, params[:description])
          present @current_user, with: Entities::UserBase
        else
          status 406
          { error: 'Invalid users token or access' }
        end
      end

      ###GET /api/user
      desc 'User information', {
      is_array: true,
      success: Entities::UserBase,
      failure: [{ code: 406, message: 'Invalid users token' }]
      }
      params do
        #requires :user_token, type: String, desc: 'users token'
      end
      get do
        if user_is_allowed @current_user
          present @current_user, with: Entities::UserBase
        else
          status 406
          { error: 'Invalid users token' }
        end
      end

      ###POST /api/users/restore_password
      desc 'Set new password', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token, name or email' }]
      }
      params do
        requires :name, type: String, desc: 'users name'
        requires :email, type: String, desc: 'users email'
      end
      post :restore_password do
        user = User.find_by email: params[:email], name: params[:name]
        if user_is_allowed user
          p_new = password_generate
          user.update_attribute(:password, p_new)
          EmailSendJob.perform_later(user.email, p_new)
          return { message: 'success', password: p_new }
        end
        status 406
        { error: 'Invalid name or email' }
      end

    end
  end
end