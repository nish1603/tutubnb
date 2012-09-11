class ProfileController < ApplicationController
  
  skip_before_filter :authorize

  def login
  end

  def validate_user
    user = User.find_by_email(params[:email])
    
    respond_to do |format|
      if user and user.authenticate(params[:password]) and user.verified == true
        session[:user_id] = user.id
        session[:user_name] = user.first_name
        session[:admin] = user.admin
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
        link = authenticate_url + "?id=#{@user.id}&activation_link=#{@user.activation_link}"
        a = Notifier.verification(link, @user.email, @user.first_name).deliver
        format.html { redirect_to display_show_path, notice: "An Email has been sent ot your e-mail address for verification." }
      else
        format.html { render action: "signup" }
      end	
    end
  end

  def authenticate
    params = request.parameters
    id = params[:id]
    activation_link = params[:activation_link]

    if id
      user = User.find(id)
    else
      redirect_to display_show_path
    end
    
    if user and user.activation_link = params[:activation_link]
      session[:user_id] = user.id
      session[:user_name] = user.first_name
      user.verified = true
      user.save(:validate => false)
      flash[:notice] = "You have verified your account successfully. #{user.save(:validate => false)}"
    else
      flash[:notice] = "Your account has not been not verified."
    end

    respond_to do |format|
      format.html{ redirect_to display_show_path }
    end
  end
end