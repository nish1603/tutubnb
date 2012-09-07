class DisplayController < ApplicationController
  
  skip_before_filter :authorize
  
  def show
  	@places = session[:places] || Place.all
    session[:places] = nil

  	respond_to do |format|
  		format.html
      format.js
    end
  end

  def search
  # 	location = params[:location]
    
  #   places = Place.find_by_location(location)
  #   session[:places] = places

  #   respond_to do |format|
  #     format.html { redirect_to display_show_path }
  #   end
  end

  
end
