class UserController < ApplicationController
  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      if(session[:user_id].nil? and session[:user_id] != @user.id)
        format.html { redirect_to display_show_path }
      else
        format.html
      end
    end
  end

  def update

    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_edit_path(params[:id]), notice: 'Updated' }
      else
        format.html { redirect_to user_edit_path(params[:id]), notice: params[:user] }
      end
    end
  end

  def listings
    @user = User.find(params[:id])
    places = @user.places
    @listings = Deal.find_listings(places)

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
    @trips = Deal.find_trips(params[:id])

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
    places = @user.places
    @requests = Deal.find_requests(places)

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
end
