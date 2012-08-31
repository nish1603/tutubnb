class ProfileController < ApplicationController
  def login
  end

  def validate_user
    user = User.find_by_email(params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.user_id
    else
      redirect_to profile_login_path
    end
  end

  def logout
    session[:user_id] = nil
  end

  def signup
  	@user = User.new
  end

  def save
  	@user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html
      else
        format.html { redirect_to profile_signup_path }
    end	
  end
  end
end
