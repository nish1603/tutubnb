class UserController < ApplicationController
  before_filter :validate_account, :except => :wallet

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

    update_wallet
    
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
end