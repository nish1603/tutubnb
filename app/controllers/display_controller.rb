class DisplayController < ApplicationController
  def show
  	@places = Place.all
  end
end
