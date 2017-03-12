class Admin::UsersController < ApplicationController
  
  def index
     @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

def update
    if @user.update_attributes(user_params)
        redirect_to @user, notice: "Account Successfully updated"
    else
        render :edit
    end
end

def destroy
  @user.destroy.find(params[:id])
end

private

    def user_params
      params.require(:user).permit(:name, :email)
    end

end
