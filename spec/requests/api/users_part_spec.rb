require "spec_helper"
require "rails_helper"
require "database_cleaner"
#require "sidekiq/testing"
require "email_spec"

include SessionHelper

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe "UsersPart" do
  include ActiveJob::TestHelper
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:all) do
    @email = UserMailer.create("jojo@yahoo.com", "Jojo Binks")
    Sidekiq::Worker.clear_all
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

    #expect(UserMailer).to(receive(:create).with(all_params[:email], "Jimmy Bean"))
    @email.deliver
    m = ActionMailer::Base.deliveries
    expect(m.count).to eq(1)

    #Sidekiq::Testing.inline! do
      expect(EmailUserCreateJob).to have(1).jobs
    #end

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



end
