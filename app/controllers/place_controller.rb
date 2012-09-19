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
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
    end

  	respond_to do |format|
      if @place.save(:validate => validate)
        format.html { redirect_to display_show_path }
        flash[:notice] = notice
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

    respond_to do |format|
      if(@place.update_attributes(params[:place]))
        flash[:notice] = notice
        format.html { redirect_to @place }
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