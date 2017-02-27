class UsersController < ApplicationController
  def index
  end

  def mail
    UserMailer.create.deliver_now
  end

  def new
    @user = User.new
  end
end
