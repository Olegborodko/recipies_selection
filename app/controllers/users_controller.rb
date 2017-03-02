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
        if user.role_id == 1
          user.role_id = 2 #subscriber
          user.save
        end
        redirect_to root_url, :notice => "Thank you now you are authorized"
      else
        user.destroy
        redirect_to root_url, :notice => "Your authorization is not valid"
      end
    else
      redirect_to root_url, :notice => "Your authorization is not valid"
    end

  end

  private
  def person_params
    params.require(:user).permit(:email, :name, :password_digest, :description)
  end

  def token
    params.permit(:id)
  end
end
