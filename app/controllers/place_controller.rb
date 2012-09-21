class PlaceController < ApplicationController

  skip_before_filter :authorize, only: :show
  before_filter :owner_activated, :only => :activate

 
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
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
    end
    
    photos = 0
    params[:place][:photos_attributes].each do |key, photo|
      unless(photo[:avatar].blank?)
        photos += 1
      end
    end

  	respond_to do |format|
      if photos >= 2 && @place.save(:validate => validate)
        format.html { redirect_to display_show_path }
        flash[:notice] = notice
      elsif(photos < 2)
        @place.valid?
        @place.errors.add(:base, "Photos should be atleast 2")
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
    
    notice = "Successfully updated."
    if(@place.hidden == true)
      notice += "It is still hidden, you can make it visible on My Places."
    end

    photos = @place.photos.count
    params[:place][:photos_attributes].each do |key, photo|
      if(!photo[:avatar].blank?)
        photos += 1
      elsif(photo["_destroy"] == "1")
        photos -= 1
      end
    end


    respond_to do |format|
      if(photos >= 2 && @place.update_attributes(params[:place]))
        flash[:notice] = notice
        format.html { redirect_to @place }
      elsif(photos < 2)
        @place.valid?
        @place.errors.add(:base, "Photos should be atleast 2")
        format.html { render action: "edit"}
      else
        format.html { render action: "edit"}
      end
    end
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
    
    if(@place.deals.completed(false).requested(true).empty?)
      @place.destroy
      flash[:notice] = "This place has been deleted"
    else
      flash[:error] = "This place can't be deleted because it has some pending details."
    end

    respond_to do |format|
      format.html { redirect_to request.referrer }
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
      if(@place.save)
        flash[:notice] = "#{@place.title} is now #{params[:flag]}"
      else
        flash[:error] = "#{@place.title} has not been verified"
      end
      format.html { redirect_to request.referrer }
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
        flash[:error] = "#{@place.title} is not #{result}."
      end
      format.html { redirect_to request.referrer }
    end
  end
end