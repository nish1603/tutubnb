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

    respond_to do |format|
      if session[:user_id] != @place.user_id
        format.html { redirect_to display_show_path }
      else
        format.html 
      end
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
  end
end
