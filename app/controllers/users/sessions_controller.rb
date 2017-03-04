class Users::SessionController < ApplicationController
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def new

  end

  def create
    if authentication(params[:email], params[:password])
      session[:user_id] = user.rid
      redirect_to root_url
    else
      flash.now[:error] = "not correct password or email"
      render :new
    end
  end
end
