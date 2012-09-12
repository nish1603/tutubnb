class UserController < ApplicationController
  before_filter :validate_account, :except => [:wallet, :activate]

  def edit
    edit_func
  end

  def update_func
    update_func("edit", "details")
  end

  def change_dp
    edit_func
  end

  def update_dp
    update_func("change_dp", "profile pic")
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

  def show
  end

  def edit_func
     @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def update_func(render_option, message)
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => render_option }
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
        flash[:notice] = "Acoount #{user.first_name} has been activated"
      else
        flash[:error] = "Acoount #{user.first_name} has not been activated"
      end
      format.html { redirect_to admin_users_path }
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    if(session[:admin] != true)
      session[:user_id] = nil
      session[:user_name] = nil
      session[:admin] = nil
    end

    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.json { head :no_content }
    end

    def change_password
      @user = User.find(params[:id])
    end

    def update_password
      @user = User.find(params[:id])
      
      respond_to do |format|
        if(@user and @user.authenticate(:old_password) and @user.update_attributes(params[:user]))
          format.html { redirect_to display_show_path }
        end
      end
    end
  end
end