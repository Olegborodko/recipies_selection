module Modules

  class UsersPart < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    resource :users do

      ###POST api/users
      desc 'Create a new user', {
      is_array: true,
      success: { code: 201, model: Entities::UserCreate },
      failure: [{ code: 406, message: 'Parameters contain errors' }]
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
        user = User.new(declared(params, include_missing: false)[:user])
        if user.save
          present user, with: Entities::UserCreate, message: 'Please use token in 24 hours, else user will delete', token: token_encode(user.rid)
        else
          status 406
          { errors: user.errors }
        end
      end


      ##GET /api/users/verification
      desc 'User verification', {
      is_array: false,
      success:  { massage: 'authorized' },
      failure:  [{ code: 401, message: 'Invalid key' },
                 { code: 406, message: 'Error time audentification' }]
      }
      params do
        requires :user_token, desc: 'users token'
      end
      get 'verification/:user_token' do
        user = get_user_from_token(declared(params, include_missing: false)[:user_token])
        if user
          time_now = Time.now
          if user.created_at + User.time_for_audentification > time_now
            user.status = "subscriber"
            user.save(validate: false)
            return { messages: 'authorized' }
          else
            user.destroy
            status 406
            return { error: 'error time audentification' }
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
        user = api_helper_authentication( declared(params)[:email], declared(params)[:password] )

        if user
          { token: token_encode(user.rid), message: 'login success' }
        else
          status 406
          { error: 'Not correct password or email' }
        end
      end

      ##PATCH /api/users/:user_token
      desc 'User update', {
      is_array: true,
      success: Entities::UserUpdate,
      failure: [{ code: 406, message: 'Invalid parameter entry' }]
      }
      params do
        requires :user_token, type: String, desc: 'users token'
        requires :description, type: String, desc: 'users description'
      end
      patch do
        user = get_user_from_token(declared(params, include_missing: false)[:user_token])
        if user
          user.update_attribute(:description, declared(params, include_missing: false)[:description])
          present user, with: Entities::UserUpdate
        else
          status 406
          { error: 'Invalid users token' }
        end
      end

      ###GET /api/users/:user_token
      desc 'User information', {
      is_array: true,
      success: Entities::UserInfo,
      failure: [{ code: 406, message: 'Invalid users token' }]
      }
      params do
        requires :user_token, type: String, desc: 'users token'
      end
      get do
        user = get_user_from_token(declared(params, include_missing: false)[:user_token])
        if user
          present user, with: Entities::UserInfo
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
        requires :user_token, type: String, desc: 'users token'
        requires :name, type: String, desc: 'users name'
        requires :email, type: String, desc: 'users email'
      end
      post :restore_password do
        user = get_user_from_token(declared(params, include_missing: false)[:user_token])
        if user
          if user.name == declared(params, include_missing: false)[:name] &&
          user.email == declared(params, include_missing: false)[:email]

            o = [("a".."z"), ("A".."Z")].map(&:to_a).flatten
            p_new = (0...20).map { o[rand(o.length)] }.join

            user.update_attribute(:password, p_new)
            return { message: 'success', password: p_new }
          end
        end
        status 406
        { error: 'Invalid name or email' }
      end

    end
  end
end