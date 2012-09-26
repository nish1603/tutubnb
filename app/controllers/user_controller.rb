class UserController < ApplicationController
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
        format.html { redirect_to user_edit_path(@user.id) }
      else
        flash[:error] = "#{message} not updated."
        format.html { render :action => render_option }
      end
    end
  end

  def wallet
    @user = User.find(params[:id])
   
    update_wallet()
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path }
      end
    end 
  end

  def update_wallet
    if params[:commit] == "Add"
      @user.wallet = @user.wallet + params[:amount].to_f
    else
      @user.wallet = @user.wallet - params[:amount].to_f
    end
  end

  def activate
    user = User.find(params[:id])
    if(params[:flag] == 'active')
      active = true
    else
      active = false
    end

    user.activated = active

    user.places.each do |place|
      place.verified = active
    end

    respond_to do |format|
      if(user.save)
        user.places.each { |place| place.save }
        flash[:notice] = "Account #{user.first_name} is now #{params[:flag]}"
      else
        flash[:error] = "Acoount #{user.first_name} has not been activated"
      end
      format.html { redirect_to admin_users_path }
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    if(@user.deals.completed(false).requested(true).empty? && @user.trips.completed(false).requested(true).empty?)
      @user.places.each do |place|
        place.destroy
      end
      @user.destroy
      redirect_to profile_login_path
      flash[:error] = "The account ha been successfully deleted."
      if(session[:admin] == false)
        session[:user_id] = nil
        session[:user_name] = nil
        session[:admin] = nil
      end
    else
      redirect_to root_url
      flash[:error] = "You can't delete the account, when it have pending requests."
    end
  end

  def change_password
    edit_func
  end

  def update_password
    update_func("change_password", "Password")
  end

  def places
    @user = User.find_by_id(params[:id])
    @places = @user.places
  end
end