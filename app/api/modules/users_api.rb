module Modules

  class UsersApi < Grape::API
    prefix 'api'
    format :json

    #helpers Helpers::ApiUserHelper
    #require 'user_helpered.rb'
    #n = Apihelpers::UserHelpered.api_helper_authentication

    #n = UserHelpered.new()

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do

    end

    resource :users do
      before do

      end

      ####################################POST api/users
      desc 'Create a new user', {
      is_array: true,
      success: { code: 201, model: Entities::UserCreate },
      failure: [{ code: 206, message: 'Parameters contain errors' }]
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
          present user, with: Entities::UserCreate, message: 'Please use token in 24 hours, else user will delete', token: token_encode(user.rid)
          ##{ user: user, message: "success, please check your email" }
        else
          status 206
          { errors: user.errors }
        end
      end


      #########################################GET /api/users/verification
      desc 'User verification', {
      is_array: false,
      success: { massage: 'authorized' },
      failure: [{ code: 401, message: 'Invalid key' },
                { code: 406, message: 'Error time audentification' }]
      }

      params do
        requires :id, desc: 'users token'
      end

      get 'verification/:id' do

        user = token_decode(declared(params, include_missing: false)[:id]) do
          status 401
          return { error: 'Invalid key' }
        end

        if user
          time_now = Time.now

          if user.created_at + ENV['time_for_audentification'].to_i > time_now
            set_subscriber(user)
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

      #########################################POST /api/users/login
      desc 'User login', {
      is_array: true,
      success: { massage: 'login success' },
      failure: [{ code: 400, message: 'Not correct password or email' }]
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
          status 400
          { error: 'Not correct password or email' }
        end
      end


      #########################################PATCH /api/users/:id
      desc 'User update', {
      is_array: true,
      success: Entities::UserUpdate,
      failure: [{ code: 406, message: 'Invalid parameter entry' }]
      }

      params do
        requires :user_token, type: String, desc: 'users token'
        requires :description, type: String, desc: 'users description'
      end

      #patch :custom_url do
      patch do
        user = token_decode(declared(params, include_missing: false)[:user_token]) do
          status 406
          return { error: 'Invalid users token' }
        end

        if user
          user.update_attribute(:description, declared(params, include_missing: false)[:description])
          present user, with: Entities::UserUpdate
        else
          status 406
          { error: 'Invalid users token' }
        end


      end

      ############################################GET /api/users/:id
      desc 'User information', {
      is_array: true,
      success: Entities::UserInfo,
      failure: [{ code: 406, message: 'Invalid users token' }]
      }

      params do
        requires :user_token, type: String, desc: 'users token'
      end

      get do

        user = token_decode(declared(params, include_missing: false)[:user_token]) do
          status 406
          return { error: 'Invalid users token' }
        end

        if user
          present user, with: Entities::UserInfo
        else
          status 406
          { error: 'Invalid users token' }
        end
      end

      ###############################################POST /api/users/restore_password
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
        user = token_decode(declared(params, include_missing: false)[:user_token]) do
          status 406
          return { error: 'Invalid users token' }
        end

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

    #add_swagger_documentation
  end
end