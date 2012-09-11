class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show

 
  def new
  	@place = Place.new
    @place.detail = Detail.new
    @place.address = Address.new
    2.times { @place.photos << Photo.new }
  end

  def create
  	@place = Place.new(params[:place])
    @place.user_id = session[:user_id]

    @place.weekly = @place.daily * 7 if @place.weekly.nil?
    @place.weekend = @place.daily if @place.weekend.nil?
    @place.monthly = @place.daily * 30 if @place.monthly.nil?

    if(params[:commit]) == "Save Place"
      validate = false
      @place.hidden = true
    else
      validate = true
    end

  	respond_to do |format|
      if @place.save(:validate => validate)
        format.html { redirect_to display_show_path }
      else
        format.html { render action: "new" }
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
    @reviews = @place.reviews
    @review = Review.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to display_show_path }
      format.json { head :no_content }
    end
  end

  def verify
    @place = Place.find(params[:id])
    @place.verified = true

    respond_to do |format|
      if @place.save
        flash[:notice] = "#{@place.title} has been verified"
      else
        flash[:error] = "#{@place.title} has not been verified"
      end
    end
  end
end
