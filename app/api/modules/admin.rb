module Modules

  class Admin < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    resource :admin do

      # POST /api/admin/mandrill
      desc 'Mandrill newsletter', {
        is_array: true,
        success: { message: 'letters sent, or template name have error please see (log/mandrill.log)' },
        failure: [{ code: 406, message: 'not authorized' }]
      }
      params do
        requires :template_name, type: String, desc: 'template name (example - eat_template)'
        requires :template_content, type: String, desc: 'template content'
      end
      post :mandrill do
        if user_admin? @current_user
          MandrillJob.perform_later(params[:template_name], params[:template_content])
          { message: 'letters sent' }
        else
          status 406
          { error: 'not authorized' }
        end
      end

      # POST /api/admin/parser
      desc 'To parse the data', {
        is_array: true,
        success: { message: 'see the file (log/parser.log)' },
        failure: [{ code: 406, message: 'not authorized' }]
      }
      post :parser do
        if user_admin? @current_user
          ParserJob.perform_later
          { message: 'parser starts' }
        else
          status 406
          { error: 'not authorized' }
        end
      end

      # GET /api/admin/user_all/
      desc 'All users', {
        is_array: true,
        success: { message: 'success' },
        failure: [{ code: 406, message: 'not authorized' }]
      }
      get 'user_all' do
        if user_admin? @current_user
          present User.all, with: Entities::UserBase
        else
          status 406
          { error: 'not authorized' }
        end
      end

      # POST /api/admin/ban_user/
      desc 'Ban/unban user', {
        is_array: true,
        success: { message: 'success' },
        failure: [{ code: 401, message: 'not authorized' },
                  { code: 406, message: 'the user is not suitable for ban'  }]
      }
      params do
        requires :users_email, type: String, desc: 'user\'s email'
      end
      post :ban_user do
        if user_admin? @current_user
          user = User.find_by email: params[:users_email]
          if user
            if user.ban?
              user.update_attribute(:status, 'subscriber')
              return { message: "success, user's status now is #{user.status}" }
            elsif user.subscriber?
              user.update_attribute(:status, 'ban')
              return { message: "success, user's status now is #{user.status}" }
            end
          end
          status 406
          return { error: 'the user is not suitable for ban' }
        end
        status 401
        { error: 'not authorized' }
      end

      # DELETE /api/admin/{:user_email}
      desc 'Delete user', {
        is_array: true,
        success: { message: 'success' },
        failure: [{ code: 401, message: 'not authorized' },
                  { code: 406, message: 'invalid users email' }]
      }
      params do
        requires :users_email, type: String, desc: 'user\'s email'
      end
      delete 'user' do
        if user_admin? @current_user
          user = User.find_by email: params[:users_email]
          if user
            unless user.admin?
              user.destroy
              return { message: 'success' }
            end
          end
          status 406
          return { error: 'invalid users email' }
        end
      status 401
      { error: 'not authorized' }
      end

    end
  end
end