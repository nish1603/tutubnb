class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show

  def new
  	@place = Place.new
  end

  def create
  	@place = Place.new(params[:place])
    @place.user_id = session[:user_id]
    session[:place_id] = @place.id

  	respond_to do |format|
      if @place.save
        format.html { redirect_to detail_new_path }
      end
    end 
  end

  def edit
    @place = Place.find(params[:id])
    validating_owner @place.user_id, place_path(params[:id]) 
  end

  def update
    @place = Place.find(params[:id])
    update_attributes @place, :place
  end

  def show
    @place = Place.find(params[:id])
  end
end
