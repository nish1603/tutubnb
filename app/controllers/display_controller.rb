class DisplayController < ApplicationController
  
  skip_before_filter :authorize
  
  def show
    if(session[:admin] == false)
  	  @places = Place.visible
    else
      @places = Place.admin_visible | Place.visible
    end

  	respond_to do |format|
  		format.html
      format.js
    end
  end

  def search
  end

  def user
    @users = User.all
  end

  
end
