class Admin::PlacesController < ApplicationController

  before_filter :owner_activated, :only => [:activate]
  before_filter :confirm_admin, :only => [:activate]
  
  def activate
    @place = Place.find_by_id(params[:id])

    respond_to do |format|
      if(perform_activate)
        flash[:notice] = "#{@place.title} is now #{params[:flag]}"
      else
        flash[:error] = "#{@place.title} has not been verified"
      end
      format.html { redirect_to request.referrer }
    end
  end

  def perform_activate
    if(params[:flag] == "active")
      return @place.activate!
    elsif(params[:flag] == "deactive")
      return @place.deactivate!
    end
    return false
  end

end