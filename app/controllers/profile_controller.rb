class ProfileController < ApplicationController
  
  skip_before_filter :authorize
  # before_filter :user_exist_by_email, :only => [:validate_user]
  # before_filter :user_verified, :only => [:validate_user]
  # before_filter :user_activated, :only => [:validate_user]

  def login
  end

  def validate_user
    user = User.find_by_email(params[:email])
    
    respond_to do |format|
      if user and user.authenticate(params[:password]) and user.verified == true and user.activated == true
        session[:user_id] = user.id
        session[:user_name] = user.first_name
        session[:admin] = user.admin
        format.html { redirect_to display_show_path }
      elsif user and user.verified == false
        format.html { redirect_to profile_login_path }
        flash[:alert] = 'You have not verified your user account.'
      elsif user and user.activated == false
        format.html { redirect_to profile_login_path }
        flash[:alert] = 'You are blocked by the admin of this site.'
      else 
        format.html { redirect_to profile_login_path }
        flash[:error] = 'E-mail Address/Password doesn\'t match.'
      end 
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_name] = nil
    session[:admin] = nil

    respond_to do |format|
      format.html { redirect_to display_show_path }
    end
  end

  def signup
  	@user = User.new
  end

  def save
  	@user = User.new(params[:user])
    @user.activation_link = BCrypt::Password.create("activation_link")
    
    respond_to do |format|
      if @user.save
        link = authenticate_url + "?email=#{@user.email}&activation_link=#{@user.activation_link}"
        Notifier.verification(link, @user.email, @user.first_name).deliver
        flash[:alert] = "An Email has been sent at your e-mail address for verification."
        format.html { redirect_to display_show_path }
      else
        format.html { render action: "signup" }
      end	
    end
  end

  def authenticate
    params = request.parameters
    email = params[:email]
    activation_link = params[:activation_link]

    if email
      user = User.find_by_email(email)
    else
      redirect_to display_show_path
      flash[:error] = "You are not authorized to log in."
    end
    
    if user and user.activation_link == params[:activation_link]
      session[:user_id] = user.id
      session[:user_name] = user.first_name
      user.verified = true
      user.save!(:validate => false)
      flash[:notice] = "You have verified your account successfully."
    else
      flash[:error] = "Your account has not been not verified."
    end

    respond_to do |format|
      format.html{ redirect_to display_show_path }
    end
  end

  def forget_password
  end

  def send_activation_link
    user = User.find_by_email(params[:email])
    
    if(user)
      user.activation_link = BCrypt::Password.create("activation_link")
      link = change_password_url + "?email=#{user.email}&activation_link=#{user.activation_link}"
      user.verified = false
      user.save
    end

    respond_to do |format|
      if(user and user.save)
        Notifier.verification(link, user.email, user.first_name).deliver
        format.html { redirect_to profile_login_path }
        flash[:notice] = "An Email has been send to your account"
      else
        format.html { redirect_to profile_login_path }
        flash[:error] = "Not a valid E-mail Address, Please check your e-mail address."
      end
    end
  end

  def change_password
    params = request.parameters
    if(params[:email])
      @user = User.find_by_email(params[:email])
    else
      redirect_to display_show_path
    end

    respond_to do |format|
      if(@user and @user.activation_link == params[:activation_link] and @user.verified == false)
        format.html
      else
        flash[:error] = "Invalid URL."
        format.html { redirect_to display_show_path }
      end
    end
  end

  def update_password
    @user = User.find(params[:id])
      
    respond_to do |format|
      if(@user and @user.update_attributes(params[:user]))
        @user.verified = true
        @user.save
        format.html { redirect_to display_show_path }
        flash[:notice] = "Password has been successfully updated."
      else
        format.html {  render action: "change_password" }
        flash[:error] = "Password doesn't match."
      end
    end
  end
end