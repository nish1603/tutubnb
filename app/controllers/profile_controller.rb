class ProfileController < ApplicationController
  
  skip_before_filter :authorize

  def login
  end

  def validate_user
    user = User.find_by_email(params[:email])
    
    respond_to do |format|
      if user and user.authenticate(params[:password]) and user.verified == true
        user.verified = true
        session[:user_id] = user.id
        session[:user_name] = user.first_name
        format.html { redirect_to display_show_path }
      elsif user and user.verified == false
        format.html { redirect_to display_show_path, notice: 'You have not verified your user account.' }
      else 
        format.html { redirect_to profile_login_path, notice: 'E-mail Address/Password doesn\'t match.' }
      end 
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_name] = nil

    respond_to do |format|
      format.html { redirect_to display_show_path }
    end
  end

  def signup
  	@user = User.new
  end

  def save
  	@user = User.new(params[:user])
    @user.verified = true

    respond_to do |format|
      if @user.save
        format.html { redirect_to display_show_path, notice: 'An Email has been sent ot your e-mail address for verification.' }
      else
        format.html { render action: "signup" }
      end	
    end
  end
end