class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show
  before_filter :validate_owner, only: :edit

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
    validate_owner @place.user_id, show_place_path

    respond_to do |format|
      format.html 
    end
  end

  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if@place.update_attributes(params[:place])
        format.html { redirect_to @place }
      end
    end
  end

  def show
    @place = Place.find(params[:id])
  end
end
