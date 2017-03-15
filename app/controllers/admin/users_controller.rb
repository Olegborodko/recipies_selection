class Admin::UsersController < ApplicationController
  #before_action :set_user, :logged_in_user, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]
  # before_action :current_user, only: [:edit, :update, :destroy]
  attr_accessor :name, :email

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email)
  end

  # Confirms a logged-in user.
  # def logged_in_user
  #   unless logged_in?
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   end
  # end

  # Confirms the correct user.
  # def current_user
  #   @user = User.find(params[:id])
  #   redirect_to(root_url) unless current_user?(@user)
  # end

end