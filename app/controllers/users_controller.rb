class UsersController < ApplicationController
  before_action :current_user, only: [:edit, :update, :update_description, :destroy]

  def index
  end

  def new
  end

  def create
    user = User.new(person_params)

    if user.save
      EmailUserCreateJob.perform_later(user.email, user.rid)
      #UserMailer.create(user.email, user.rid).deliver_now
      redirect_to root_url, :notice => "Please check your email, for continues"
    else
      flash.now[:error] = user.errors.full_messages
      render :new
    end
  end

  def verification
    tok = Base64.decode64(params[:id])
    hmac_secret = 'autorization_secret_key_from_users08'

    begin
      decoded_token = JWT.decode tok, hmac_secret, true, { :algorithm => 'HS256' }
    rescue
      redirect_to root_url, :notice => "Your authorization is not valid" and return
    end
    user = User.find_by rid: decoded_token[0]['key']


    if user
      time_now = Time.now

      if user.created_at + ENV['time_for_audentification'].to_i > time_now
        user.update_attribute(:role_id, 2)
        redirect_to root_url, :notice => "Thank you now you are authorized"
      else
        user.destroy
        redirect_to root_url, :notice => "Your authorization is not valid"
      end
    else
      redirect_to root_url, :notice => "Your authorization is not valid"
    end

  end

  def edit

  end

  def update
    if @current_user.authenticate(user_change[:old_password])
      if user_change[:new_password] == user_change[:new_password_confirmation] && user_change[:new_password]!=''
        if @current_user.update_attribute(:password, user_change[:new_password])
          redirect_to root_url, :notice => "Your password was changed"
        else
          render edit_user_url(@current_user.id)
        end
      else
        redirect_to edit_user_url(@current_user.id), :notice => "Passwords not correct"
      end
    else
      redirect_to root_url, :notice => "Sorry, there was some error"
    end

  end

  def update_description
    if @current_user.update_attribute(:description, user_change[:description])
      redirect_to root_url, :notice => "Your description was changed"
    else
      redirect_to root_url, :notice => "Sorry, there was some error"
    end
  end

  def restore_password

  end

  def restore
    user = User.find_by email: password[:email].downcase
    if user
      if user.name == password[:name]

        o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
        p_new = (0...20).map { o[rand(o.length)] }.join

        if user.update_attribute(:password, p_new)
          EmailSendJob.perform_later(user.email, p_new)
          #UserMailer.password_new(user.email, p_new).deliver_now
          redirect_to root_url, :notice => "Success, please check your email" and return
        end
      end
    end
    redirect_to root_url, :notice => "Sorry, there was some error"
  end

  private
  def person_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :description)
  end

  def user_change
    params.require(:user_change).permit(:description, :old_password, :new_password, :new_password_confirmation)
  end

  def password
    params.require(:password).permit(:name, :email)
  end

end
