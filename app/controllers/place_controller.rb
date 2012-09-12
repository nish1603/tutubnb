class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show

 
  def new
  	@place = Place.new
    @place.detail = Detail.new
    @place.address = Address.new
    @place.rules = Rules.new
    2.times { @place.photos << Photo.new }
  end

  def create
  	@place = Place.new(params[:place])
    @place.user_id = session[:user_id]

    @place.weekend = @place.daily if @place.weekend.nil? and @place.daily
    @place.weekly = @place.daily * 5 + @place.weekend * 2 if @place.weekly.nil? and @place.daily 
    @place.monthly = @place.daily * 30 if @place.monthly.nil? and @place.daily

    if(params[:commit] == "Save Place")
      validate = false
      @place.hidden = true
    else
      validate = true
    end

    photos = 0
    params[:place][:photos_attributes].each do |key, value|
      if(!value[:avatar].nil?)
        photos += 1
      end
    end

  	respond_to do |format|
      if photos >= 2 and @place.save(:validate => validate)
        format.html { redirect_to display_show_path }
      elsif photos < 2
        @place.errors.add(:base, "Photos should be at least 2")
        format.html { render action: "new" }
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
    @detail = @place.detail
    @rules = @place.rules
    @address = @place.address
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

  def activate
    @place = Place.find(params[:id])

    if(params[:flag] == 'active')
      active = true
    else
      active = false
    end
    @place.verified = active

    respond_to do |format|
      if @place.save
        flash[:notice] = "#{@place.title} has been verified"
      else
        flash[:error] = "#{@place.title} has not been verified"
      end
      format.html { redirect_to display_show_path }
    end
  end
end