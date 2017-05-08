require "spec_helper"
require "rails_helper"
require "database_cleaner"
require "email_spec"

include SessionHelper
include UserHelpers

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe "Admin" do
  include ActiveJob::TestHelper
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before do
    @user = create(:user, status:'admin')
    @token = token_encode(@user.rid)
  end

  after do
    clear_enqueued_jobs
  end

  it "Mandrill newsletter" do
    all_params = { template_name: 'eat_template', template_content: 'have a good day', api_key: @token }
    post '/api/admin/mandrill', params: all_params
    expect(response.status).to eq 201
  end

  it "Mandrill newsletter (error)" do
    all_params = { template_name: 'eat_template', template_content: 'have a good day', api_key: 'fail' }
    post '/api/admin/mandrill', params: all_params
    expect(response.status).to eq 406
  end

  it "To parse the data" do
    post '/api/admin/parser', params: { api_key: @token }
    expect(response.status).to eq 201
    expect(enqueued_jobs.size).to eq(1)
  end

  it "To parse the data (error)" do
    @user.subscriber!
    post '/api/admin/parser', params: { api_key: @token }
    expect(response.status).to eq 406
    expect(enqueued_jobs.size).to eq(0)
  end

  it "All users" do
    get '/api/admin/user_all', params: { api_key: @token }
    expect(response.status).to eq 200
  end

  it "All users (error)" do
    @user.subscriber!
    get '/api/admin/user_all', params: { api_key: @token }
    expect(response.status).to eq 406
  end

  it "Ban/unban user (ban)" do
    user = create(:user, status:'subscriber')
    post '/api/admin/ban_user', params: { api_key: @token, users_email: user.email }
    expect(response.status).to eq 201
  end

  it "Ban/unban user (unban)" do
    user = create(:user, status:'ban')
    post '/api/admin/ban_user', params: { api_key: @token, users_email: user.email }
    expect(response.status).to eq 201
  end

  it "Ban/unban user (error not autorized)" do
    post '/api/admin/ban_user', params: { api_key: 'fail', users_email: @user.email }
    expect(response.status).to eq 401
  end

  it "Ban/unban user (error user not suitable)" do
    post '/api/admin/ban_user', params: { api_key: @token, users_email: 'fail' }
    expect(response.status).to eq 406
  end

  it "Delete user" do
    user = create(:user, status:'subscriber')
    delete '/api/admin/user', params: { api_key: @token, users_email: user.email }
    expect(response.status).to eq 200
  end

  it "Delete user (error not authorized)" do
    delete '/api/admin/user', params: { api_key: 'fake', users_email: "#{Faker::Internet.unique.email}" }
    expect(response.status).to eq 401
  end

  it "Delete user (error email)" do
    delete '/api/admin/user', params: { api_key: @token, users_email: @user.email }
    expect(response.status).to eq 406
  end

end