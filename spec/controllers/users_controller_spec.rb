require "spec_helper"
require "rails_helper"
require "email_spec"

describe UsersController do

  User.delete_all

  before(:all) do
    @email_for_test = "220v2@mail.ru"

    @user = User.new
    @user.email = "2@2.ru"
    @user.name = "test"
    @user.password = "222222"
    @user.password_confirmation = "222222"
    @user.description = "test"
    @user.save
  end


  it "create" do
    post :create, params: {user: {email: @email_for_test,
                                  password: "333333",
                                  password_confirmation: "333333",
                                  name:"test",
                                  description: "test"}}
    user = User.last
    expect(user.email).to eq(@email_for_test)

    #last_delivery = ActionMailer::Base.deliveries.last
    #expect(@email_for_test).to eq(last_delivery[0])
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.body.raw_source.should include "This is the text of the email"

    is_expected.to redirect_to(root_url)
  end

  it "verification" do

  end

end