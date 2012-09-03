class UserController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update

    @user = User.find(params[:id])

    respond_to do |format|
      if to_update.update_attributes(params[type_to_update])
        format.html { redirect_to to_update }
      else
        format.html
      end
    end
  end

  def listings
    user = User.find(params[:id])
    places = user.places
    @listings = Deal.find_listings(places)
  end

  def trips
    @trips = Deal.find_all_by_user_id(params[:id])
  end

  def requests
    @requests = Deal.find_requests(params[:id])
  end
end
