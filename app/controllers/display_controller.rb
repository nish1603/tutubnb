class DisplayController < ApplicationController
  
  skip_before_filter :authorize
  
  def show
  	@places = Place.all
  end
end
