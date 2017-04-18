module Modules

  class Admin < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    resource :admin do

      ###POST /api/admin/mandrill
      desc 'Mandrill newsletter', {
      is_array: true,
      success: { message: 'letters sent, or template name have error please see (log/mandrill.log)' },
      failure: [{ code: 406, message: 'not authorized' }]
      }
      params do
        requires :admin_token, type: String, desc: 'admins token'
        requires :template_name, type: String, desc: 'template name (example - eat_template)'
        requires :template_content, type: String, desc: 'template content'
      end
      post :mandrill do
        user = get_user_from_token(all_params_hash['admin_token'])
        if user
          if user.admin?
            MandrillJob.perform_later(all_params_hash['template_name'], all_params_hash['template_content'])
            return { message: 'letters sent' }
          end
        end
        status 406
        { error: 'not authorized' }
      end

      ###POST /api/admin/parser
      desc 'To parse the data', {
      is_array: true,
      success: { message: 'see the file (log/parser.log)' },
      failure: [{ code: 406, message: 'not authorized' }]
      }
      params do
        requires :admin_token, type: String, desc: 'admins token'
      end
      post :parser do
        user = get_user_from_token(all_params_hash['admin_token'])
        if user
          if user.admin?
            ParserJob.perform_later
            return { message: 'parser starts' }
          end
        end
        status 406
        { error: 'not authorized' }
      end

      ###GET /api/admin/user_all/
      desc 'All users', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'not authorized' }]
      }
      params do
        requires :admin_token, type: String, desc: 'admins token'
      end
      get 'user_all' do
        user = get_user_from_token(all_params_hash['admin_token'])
        if user
          if user.admin?
            return present User.all, with: Entities::UserInfo
          end
        end
        status 406
        { error: 'not authorized' }
      end

    end
  end
end