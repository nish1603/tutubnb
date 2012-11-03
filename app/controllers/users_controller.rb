class UsersController < ApplicationController
  #FIXME_AB: admin related functionality should go in admin namespace
  skip_before_filter :authorize, :only => [:new, :create, :authenticate, :forgotton_password, :change_forgotton_password, :update_forgotton_password, :send_activation_link]
  before_filter :validate_account, :except => [:wallet, :activate, :destroy, :new, :create, :forgotton_password, :change_forgotton_password, :update_forgotton_password]
  before_filter :validate_account_for_destroy, :only => :destroy
  before_filter :user_logged_in, :only => [:signup, :authenticate, :forgotton_password, :change_forgotton_password, :update_forgotton_password]

  def edit
    edit_func
  end

  def update
    update_func("edit", "Details")
  end

  def change_dp
    edit_func
  end

  def update_dp
    update_func("change_dp", "Profile Pic")
  end

  def visits
    @user = User.find_by_id(params[:id])
    @visits = Deal.find_visits_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def trips
    @user = User.find_by_id(params[:id])
    @trips = Deal.find_trips_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def requests
    @user = User.find_by_id(params[:id])
    @requests = Deal.find_requests_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def requested_trips
    @user = User.find_by_id(params[:id])
    @requested_trips = Deal.find_requested_trips_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def edit_func
    @user = User.find_by_id(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update_func(render_option, message)
    @user = User.find_by_id(params[:id])

    respond_to do |format|
      if(@user.update_attributes(params[:user]))
        flash[:notice] = "#{message} updated."
        format.html { redirect_to edit_user_path(@user.id) }
      else
        flash[:error] = "#{message} not updated."
        format.html { render :action => render_option }
      end
    end
  end

  def wallet
    @user = User.find(params[:id])

    @user.update_wallet(params[:commit], params[:amount].to_f)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path }
      end
    end
  end

  def activate
    @user = User.find(params[:id])

    respond_to do |format|
      if(perform_activate(@user))
        flash[:notice] = "Account #{@user.first_name} is now #{params[:flag]}"
      else
        flash[:error] = "Acoount #{@user.first_name} has not been activated"
      end
      format.html { redirect_to admin_users_path }
    end
  end

  def perform_activate(user)
    if(params[:flag] == "active")
      return user.activate!
    elsif(params[:flag] == "deactive")
      return user.deactivate!
    end
    return false
  end

  def destroy
    @user = User.find_by_id(params[:id])

    if(@user.destroy)
      clear_session() unless(session[:admin])
      flash[:error] = "The account has been successfully deleted."
    else
      flash[:error] = "You can't delete the account, when it have pending requests."
    end
    redirect_to root_url
  end

  def change_password
    edit_func
  end

  def update_password
    update_func("change_password", "Password")
  end

  def register_with_site
    edit_func
  end

  def update_information
    update_func("register_with_site", "Email and Password")
    @user.activation_link = BCrypt::Password.create("activation_link")
    link = authenticate_url + "?email=#{@user.email}&activation_link=#{@user.activation_link}"
    Notifier.verification(link, @user.email, @user.first_name).deliver
  end

  def places
    @user = User.find_by_id(params[:id])
    @places = @user.places
  end

  def new 
    @user = User.new
  end

#FIXME_AB: users/create
  def create
    @user = User.new(params[:user])
    @user.activation_link = BCrypt::Password.create("activation_link")

    respond_to do |format|
      if @user.save
        link = authenticate_users_url + "?email=#{@user.email}&activation_link=#{@user.activation_link}"
        Notifier.verification(link, @user.email, @user.first_name).deliver
        flash[:alert] = "An Email has been sent at your e-mail address for verification."
        format.html { redirect_to root_url }
      else
        format.html { render action: "new"}
      end
    end
  end

#FIXME_AB: users/activate
  def authenticate
    params = request.parameters
    user = User.find_by_email(params[:email])


    respond_to do |format|
      if(user && user.activation_link == params[:activation_link])
        set_session(user)
        user.activation_link = nil
        user.verified = true
        user.save(:validate => false)
        flash[:notice] = "You have verified your account successfully."
      else
        flash[:error] = "Your account has not been verified."
      end
      format.html { redirect_to root_url }
    end
  end

#FIXME_AB: users/forgotten_password
  def forgotton_password
  end

  def send_activation_link
    user = User.find_by_email(params[:email])

    if(user)
      user.activation_link = BCrypt::Password.create("activation_link")
      link = change_forgotton_password_users_url + "?email=#{user.email}&activation_link=#{user.activation_link}"
      user.verified = false
    end

    respond_to do |format|
      if(user && user.save)
        Notifier.verification(link, user.email, user.first_name).deliver
        format.html { redirect_to login_sessions_path }
        flash[:notice] = "An Email has been send to your account"
      else
        format.html { redirect_to login_sessions_path }
        flash[:error] = "Not a valid E-mail Address, Please check your e-mail address."
      end
    end
  end

  def change_forgotton_password
    params = request.parameters
    @user = User.find_by_email(params[:email])

    respond_to do |format|
      if(@user && @user.activation_link == params[:activation_link] && @user.verified == false)
        format.html
      else
        flash[:error] = "Invalid URL."
        format.html { redirect_to root_url }
      end
    end
  end

  def update_forgotton_password
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      if(@user && @user.update_attributes(params[:user]))
        @user.verified = true
        @user.save
        format.html { redirect_to root_url }
        flash[:notice] = "Password has been successfully updated."
      else
        format.html { render action: "change_forgotton_password" }
        flash[:error] = "Password doesn't match."
      end
    end
  end


  protected
    def validate_account_for_destroy
      unless(session[:admin] != true && session[:user_id] != params[:id])
        redirect_to root_url
      end
    end
end