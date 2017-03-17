class Users::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { key_have }

  def destroy
    #session.delete(:user_id)
    #session[:user_id] = nil
    reset_session
    @current_user = nil

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: { message: "session destroy" }, status: :ok }
    end
  end

  def new
  end

  def create
    respond_to do |format|
      if authentication(person_params[:email], person_params[:password])
        format.html { redirect_to root_url, :notice => "You are logged in" }
        format.json { render json: { message: "logged in" }, status: :ok }
      else
        flash.now[:error] = "Not correct password or email"
        format.html { render :new }
        format.json { render json: { message: "not correct password or email" }, status: :unprocessable_entity }
      end
    end
  end

  private
  def person_params
    params.require(:session).permit(:email, :password)
  end

end
