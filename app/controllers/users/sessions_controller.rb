class Users::SessionsController < ApplicationController
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def new

  end

  def create
    if authentication(person_params[:email], person_params[:password])
      redirect_to root_url, :notice => "You are logged in"
    else
      flash.now[:error] = "Not correct password or email"
      render :new
    end
  end

  private
  def person_params
    params.require(:session).permit(:email, :password)
  end
end
