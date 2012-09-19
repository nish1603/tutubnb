class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show

 
  def new
  	@place = Place.new
    @place.detail = Detail.new
    @place.address = Address.new
    @place.rules = Rules.new
    @tags = Tag.all.map(&:tag)

    2.times { @place.photos << Photo.new }
    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end

  def create
  	@place = Place.new(params[:place])
    @place.user_id = session[:user_id]


    if(params[:commit] == "Save Place")
      validate = false
      @place.hidden = true
    else
      validate = true
    end

    photos = 0
    params[:place][:photos_attributes].each do |key, value|
      unless(value[:avatar].nil?)
        photos += 1
      end
    end

  	respond_to do |format|
      if((validate == false or photos >= 2) and @place.save(:validate => validate))
        if(@place.daily and @place.daily >= 0)
          @place.weekend = @place.daily if @place.weekend.nil?
          @place.weekly = @place.daily * 5 + @place.weekend * 2 if @place.weekly.nil? 
          @place.monthly = @place.daily * 30 if @place.monthly.nil?
        end
        logger.info "hi"
        logger.info params
        @place.save(:validate => validate)
        format.html { redirect_to display_show_path }
        if(validate == true)
          flash[:notice] = "Your place has been created."
        else
          flash[:notice] = "Your place has been saved. But it is hidden from the outside world."
        end
      elsif photos < 2
        logger.info "hi"
        logger.info params
        @place.valid?
        @place.errors.add(:base, "Photos should be at least 2")
        format.html { render action: "new" }
      else
        logger.info "hi"
        logger.info params
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

    photos = 0
    params[:place][:photos_attributes].each do |key, value|
      if(!value[:avatar].nil?)
        photos += 1
      else
        params[:place][:photos_attributes].delete(key)
      end
    end
    update_attributes @place, photos, :place
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
    
    if(@place.user.activated == true)
      @place.verified = active
    end

    respond_to do |format|
      if(@place.user.activated == false)
        flash[:alert] = "Owner of this place is deactivated. Please activate him first."
      elsif(@place.save)
        flash[:notice] = "#{@place.title} is now #{params[:flag]}"
      else
        flash[:error] = "#{@place.title} has not been verified"
      end
      format.html { redirect_to display_show_path }
    end
  end

  def operation
    @place = Place.find(params[:id])

    if(params[:flag] == 'hide')
      active = true
      result = "hidden"
    else
      active = false
      result = "visible"
    end
    
    if(@place.user.activated == true)
      @place.hidden = active
    end

    respond_to do |format|
      if(@place.save)
        flash[:notice] = "#{@place.title} is now #{result}"
      else
        flash[:error] = "#{@place.title} has not been verified."
      end
      format.html { redirect_to display_show_path }
    end
  end
end