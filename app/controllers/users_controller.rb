class UsersController < ApplicationController
  def index
  end

  #def mail_autorization
  #  UserMailer.create.deliver_now
  #end

  def new
  end

  def create
    user = User.new(person_params)
    user.role_id = 1 #unauthorized

    if user.save
      UserMailer.create(user.email, user.rid).deliver_now
      redirect_to root_url, :notice => "Please check your email, for continues"
    else
      flash.now[:error] = user.errors.full_messages
      render :new
    end
  end

  def verification

  end

  private
  def person_params
    params.require(:user).permit(:email, :name, :password_digest, :description)
  end
end
