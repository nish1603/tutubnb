class PlacesController < ApplicationController  
  skip_before_filter :authorize, only: :show
  before_filter :owner_activated, :only => [:activate, :operation]
  before_filter :place_exists, :only => [:edit, :update, :operation, :show]
  before_filter :validating_owner, :only => [:edit, :update, :operation]

  caches_action :new, :layout => false
  caches_action :show, :expires_in => 10

  def new
  	@place = Place.new
    @place.build_detail 
    @place.build_address
    @place.build_rules

    2.times { @place.photos.build }
    respond_to do |format|
      format.html
    end
  end

  def create
  	@place = Place.new(params[:place])
    @place.user_id = session[:user_id]

    validate, notice = check_commit(@place)
    
  	respond_to do |format|
      if(@place.save(:validate => validate))  
        format.html { redirect_to root_url }
        flash[:notice] = notice
      else
        format.html { render action: "new" }
      end
    end 
  end

  def edit
    @place = Place.find_by_id(params[:id]) 
  end

  def update
    @place = Place.find_by_id(params[:id], :lock => true)
      
    notice = "Successfully updated."
    notice += "It is still hidden, you can make it visible on My Places." if(@place.hidden == true)

    respond_to do |format|
      if(@place.update_attributes(params[:place]))
        format.html { redirect_to display_show_path }
        flash[:notice] = notice
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @place = Place.find_by_id(params[:id])
    @user = User.find_by_id(session[:id])
    @deal = Deal.unreviewed_by_user_on_place(@user, @place).first if(@user)
    @detail = @place.detail
    @rules = @place.rules
    @address = @place.address
    @reviews = @place.reviews
    @review = Review.new
    @address_json = @address.to_gmaps4rails
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @place = Place.find_by_id(params[:id])
    
    respond_to do |format|
      if(@place.destroy)
        flash[:notice] = "This place has been deleted"
      else
        flash[:error] = "This place can't be deleted because it has some pending deals."
      end
      format.html { redirect_to request.referrer }
    end
  end

  def operation
    @place = Place.find_by_id(params[:id])

    respond_to do |format|
      if(params[:flag] == "hide" && @place.hide!)
        flash[:notice] = "#{@place.title} is now hidden"
      elsif(params[:flag] == "show" && @place.show!)
        flash[:notice] = "#{@place.title} is now visible"
      else
        flash[:error] = "#{@place.title} is not visible."
      end
      format.html { redirect_to request.referrer }
    end
  end

  def check_commit(place)
    if(params[:commit] == "Save Place")
      validate = false
      place.hidden = true
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
    end
    return validate, notice
  end

end