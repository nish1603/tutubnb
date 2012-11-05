class DisplayController < ApplicationController  
  skip_before_filter :authorize
  
  def show
    if(current_user && current_user.admin == true)
      @places = Place.hidden(false)
    else
      @places = Place.verified(true)
    end
    
  	respond_to do |format|
  		format.html
      format.js 
    end
  end
end
