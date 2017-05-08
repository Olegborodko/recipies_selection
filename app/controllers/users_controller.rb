class UsersController < ApplicationController
  before_action :current_user, only: [:edit, :update, :update_description, :destroy]
  skip_before_action :verify_authenticity_token, if: -> { key_have }

  def index
  end

  def new
  end

  def create
    respond_to do |format|
      user = User.new(person_params)

      if user.save
        path = token_encode(user.rid)
        EmailUserCreateJob.perform_later(user.email, path)
        #UserMailer.create(user.email, user.rid).deliver_now

        format.html { redirect_to root_url, notice: "Please check your email, for continues" }
        format.json { render json: {user: user, message: "success, please check your email"}, status: :created }
      else
        flash.now[:error] = user.errors.full_messages
        format.html { render :new }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def verification

    user = get_user_from_token(params[:id])

    respond_to do |format|
      if user
        time_now = Time.now

        if user.created_at + User.time_for_authentification > time_now
          user.status = "subscriber"
          user.save(validate: false)
          format.html { redirect_to root_url, notice: "Thank you now you are authorized" and return }
          format.json { render json: {message: "authorized"}, status: :ok and return }
        else
          user.destroy
          format.html { redirect_to root_url, notice: "Your authorization is not valid" and return }
          format.json { render json: {message: "error time authentification"}, status: :unprocessable_entity and return }
        end
      end
      format.html { redirect_to root_url, notice: "Your authorization is not valid" }
      format.json { render json: {message: "key is invalid"}, status: :unprocessable_entity }
    end

  end

  def edit
  end

  def update
    respond_to do |format|
      if @current_user.authenticate(user_change[:old_password])
        if user_change[:new_password] == user_change[:new_password_confirmation] && user_change[:new_password]!=''
          if @current_user.update_attribute(:password, user_change[:new_password])
            format.html { redirect_to root_url, notice: "Your password was changed" }
            format.json { render json: {message: "password was changed"}, status: :ok }
          else
            format.html { render edit_user_url(@current_user.id) }
            format.json { render json: {message: "error with saving password"}, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to edit_user_url(@current_user.id), notice: "Password is not correct" }
          format.json { render json: {message: "passwords is not correct"}, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_url, notice: "Sorry, there was some error" }
        format.json { render json: {message: "error with authenticate"}, status: :unprocessable_entity }
      end
    end
  end

  def update_description
    respond_to do |format|
      if @current_user.update_attribute(:description, user_change[:description]) && @current_user.role_id != 1
        format.html { redirect_to root_url, notice: "Your description was changed" }
        format.json { render json: {message: "description was changed"}, status: :ok }
      else
        format.html { redirect_to root_url, notice: "Sorry, there was some error" }
        format.json { render json: {message: "there was some error"}, status: :unprocessable_entity }
      end
    end
  end

  def restore_password
  end

  def restore
    user = User.find_by email: password[:email].downcase

    respond_to do |format|
      if user
        if user.name == password[:name]
          p_new = password_generate

          if user.update_attribute(:password, p_new)
            EmailSendJob.perform_later(user.email, p_new)
            #UserMailer.password_new(user.email, p_new).deliver_now

            format.html { redirect_to root_url, notice: "Success, please check your email" and return }
            format.json { render json: {message: "success, please check your email"}, status: :ok and return }
          end
        end
      end
      format.html { redirect_to root_url, notice: "Sorry, there was some error" }
      format.json { render json: {message: "there was some error"}, status: :unprocessable_entity }
    end

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
