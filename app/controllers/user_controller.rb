class UserController < ApplicationController
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
      if(session[:user_id].nil? and session[:user_id] != @user.id)
        format.html { redirect_to display_show_path }
      else
        format.html
      end
    end
  end

  def trips
    @user = User.find(params[:id])
    @trips = Deal.find_trips_of_user(@user)

    respond_to do |format|
      if(session[:user_id].nil? and session[:user_id] != @user.id)
        format.html { redirect_to display_show_path }
      else
        format.html
      end
    end
  end

  def requests
    @user = User.find(params[:id])
    @requests = Deal.find_requests_of_user(@user)

    respond_to do |format|
      if(session[:user_id].nil? and session[:user_id] != @user.id)
        format.html { redirect_to display_show_path }
      else
        format.html
      end
    end
  end

  def show
  end

  def edit_func
     @user = User.find(params[:id])
    
    respond_to do |format|
      if(session[:user_id].nil? and session[:user_id] != @user.id)
        format.html { redirect_to display_show_path }
      else
        format.html
      end
    end
  end

  def update_func(render_option, message)
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_edit_path(params[:id]), notice: "Your #{message} has been updated." }
      else
        format.html { render :action => render_option }
      end
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