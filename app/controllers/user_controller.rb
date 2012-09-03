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
    @listings = Deal.find_listings(params[:id])
  end

  def trips
    @trips = Deal.find_trips(params[:id])
  end

  def requests
    @requests = Deal.find_requests(params[:id])
  end
end
