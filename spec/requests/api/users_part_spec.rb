require "spec_helper"
require "rails_helper"
require "database_cleaner"
require "email_spec"

include SessionHelper
include UserHelpers

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe "UsersPart" do
  include ActiveJob::TestHelper
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before do
    @email_user_create = UserMailer.create("jojo@yahoo.com", "Jojo Binks")
    @email_password_restore = UserMailer.password_new("jojo@yahoo.com", "qqq111")

    @user = User.create(email: Faker::Internet.unique.email, status:"unauthorized", password: password_generate, name: Faker::Name.name)
    @token = token_encode(@user.rid)
  end

  after do
    clear_enqueued_jobs
  end

  it "Create a new user" do
    password = password_generate
    all_params = { email: Faker::Internet.unique.email,
                   name: Faker::Name.name ,
                   password: password,
                   password_confirmation: password }
    post '/api/users', params: all_params
    expect(response.status).to eq 201
    expect(enqueued_jobs.size).to eq(1)
    #expect(@email).to have_subject("Registration confirmation")

    expect( @email_user_create.deliver ).to deliver_to("jojo@yahoo.com")
    expect( @email_user_create.deliver ).to have_body_text("Jojo Binks")

    #expect(EmailUserCreateJob).to have(1).jobs

    #@email.deliver
    #m = ActionMailer::Base.deliveries
    #expect(m.count).to eq(1)

    #expect(EmailUserCreateJob.instance_method :perform).to be_delayed

  end

  it "Create a new user (error)" do
    all_params = { email: Faker::Internet.unique.email,
                   name: Faker::Name.name,
                   password: 'fail',
                   password_confirmation: 'fail' }
    post '/api/users', params: all_params
    expect(response.status).to eq 406
    expect(enqueued_jobs.size).to eq(0)
  end

  it "User verification" do
    all_params = { api_key: @token }
    get '/api/users/verification', params: all_params
    expect(response.status).to eq 200
    user = User.find_by email: @user[:email]
    expect(user.status).to eq 'subscriber'
  end

  it "User verification (error)" do
    all_params = { api_key: 'fake' }
    get '/api/users/verification', params: all_params
    expect(response.status).to eq 401
  end

  it "User verification time (error)" do
    @user.created_at -= User.time_for_authentification
    @user.save
    all_params = { api_key: @token }
    get '/api/users/verification', params: all_params
    expect(response.status).to eq 406
    user = User.find_by email: @user[:email]
    expect(user).to eq nil
  end

  it "User login" do
    @user.status = 'subscriber'
    @user.save
    all_params = { email: @user.email, password: @user.password }
    post '/api/users/login', params: all_params
    expect(response.status).to eq 201
  end

  it "User login (error)" do
    all_params = { email: @user.email, password: @user.password }
    post '/api/users/login', params: all_params
    expect(response.status).to eq 406
  end

  it "User update" do
    @user.status = 'subscriber'
    @user.save
    all_params = { api_key: @token, description: 'new description' }
    patch '/api/users/', params: all_params
    expect(response.status).to eq 200
    expect(User.last.description).to eq 'new description'
  end

  it "User update (error)" do
    all_params = { api_key: 'fake', description: 'new description' }
    patch '/api/users/', params: all_params
    expect(response.status).to eq 406
  end

  it "Set new password" do
    @user.status = 'subscriber'
    @user.save
    expect(api_helper_authentication(@user.email, @user.password)).to eq @user

    all_params = { name: @user.name, email: @user.email }
    post '/api/users/restore_password', params: all_params
    expect(response.status).to eq 201
    expect(api_helper_authentication(@user.email, @user.password)).not_to eq @user
    expect(enqueued_jobs.size).to eq(1)

    expect( @email_password_restore.deliver ).to deliver_to("jojo@yahoo.com")
    expect( @email_password_restore.deliver ).to have_body_text("qqq111")
  end

  it "Set new password (error)" do
    all_params = { name: @user.name, email: @user.email }
    post '/api/users/restore_password', params: all_params
    expect(response.status).to eq 406
    expect(enqueued_jobs.size).to eq(0)
  end

  it "User information" do
    @user.status = 'subscriber'
    @user.save
    all_params = { api_key: @token }
    get '/api/users', params: all_params
    expect(response.status).to eq 200
  end

  it "User information (error)" do
    all_params = { api_key: 'fake' }
    get '/api/users', params: all_params
    expect(response.status).to eq 406
  end

end
