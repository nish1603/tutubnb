class UserController < ApplicationController
  #FIXME_AB: admin related functionality should go in admin namespace
  before_filter :validate_account, :except => [:wallet, :activate]

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
    #FIXME_AB: you nee user in almost all actions. Use before_filter
    #FIXME_AB: What if user not found with the id
    @user = User.find(params[:id])
    @visits = Deal.find_visits_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def trips
    @user = User.find(params[:id])
    @trips = Deal.find_trips_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def requests
    @user = User.find(params[:id])
    @requests = Deal.find_requests_of_user(@user)

    respond_to do |format|
      format.html
    end
  end

  def requested_trips
    @user = User.find(params[:id])
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
    @user.activate_or_deactivate_user(params[:flag])

    respond_to do |format|
      if(@user.save!)
        flash[:notice] = "Account #{@user.first_name} is now #{params[:flag]}"
      else
        flash[:error] = "Acoount #{@user.first_name} has not been activated"
      end
      format.html { redirect_to admin_users_path }
    end
  end

  def destroy
    @user = User.find(params[:id])

    if(@user.destroy)
      clear_session() unless(session[:admin])
      flash[:error] = "The account ha been successfully deleted."
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
end
