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
  end

  
end
